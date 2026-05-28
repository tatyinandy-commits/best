#!/usr/bin/env python3
"""build-catalog.py — пересобирает catalog.json из файлов коллекции.

Сканирует skills/, agents/, commands/, prompts/, docs/, scripts/ и извлекает
имя + описание каждого элемента, сохраняя верхнеуровневые метаданные и
описания форматов из существующего catalog.json. Шаблоны (_template*) и README
игнорируются.

Использование:
    python3 scripts/build-catalog.py          # пересобрать и записать
    python3 scripts/build-catalog.py --check   # проверить без записи (CI)
"""
from __future__ import annotations

import datetime as _dt
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "catalog.json"

SKIP_STEMS = {"README", "_template"}


def _is_template(p: Path) -> bool:
    return p.stem in SKIP_STEMS or p.name.startswith("_template")


def _frontmatter(text: str) -> dict[str, str]:
    """Минимальный парсер YAML-frontmatter: name/description, в т.ч. свёрнутые."""
    if not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end == -1:
        return {}
    body = text[3:end].strip("\n").splitlines()
    fields: dict[str, str] = {}
    key = None
    buf: list[str] = []

    def flush():
        nonlocal key, buf
        if key is not None:
            fields[key] = " ".join(s.strip() for s in buf).strip()
        key, buf = None, []

    for line in body:
        m = re.match(r"^(\w+):\s*(.*)$", line)
        if m and not line.startswith((" ", "\t")):
            flush()
            key = m.group(1)
            val = m.group(2).strip()
            if val in (">", "|", ">-", "|-", ">+", "|+"):
                buf = []
            else:
                buf = [val]
        elif key is not None:
            buf.append(line)
    flush()
    return fields


def _prompt_desc(text: str) -> str:
    """Описание промпта: блок '> Назначение: ...' до строки '> Теги'/пустой."""
    lines = text.splitlines()
    parts: list[str] = []
    started = False
    for line in lines:
        s = line.strip()
        if not started:
            if s.startswith(">") and re.search(r"Назначение:", s):
                started = True
                parts.append(re.sub(r"^>\s*Назначение:\s*", "", s))
            continue
        if not s.startswith(">"):
            break
        body = s.lstrip("> ").strip()
        if body.startswith("Теги"):
            break
        parts.append(body)
    return " ".join(parts).strip()


def _first_paragraph(text: str) -> str:
    """Первый текстовый абзац после заголовка (склеивает перенос строк)."""
    parts: list[str] = []
    for line in text.splitlines():
        s = line.strip()
        if not parts:
            if not s or s.startswith("#"):
                continue
            parts.append(s)
        else:
            if not s:
                break
            parts.append(s)
    return " ".join(parts).strip()


def _script_desc(p: Path, text: str) -> str:
    """Описание скрипта: docstring (.py) или первый комментарий (.sh)."""
    if p.suffix == ".py":
        m = re.search(r'"""(.*?)(?:\n|""")', text, re.S)
        if m:
            first = m.group(1).strip().splitlines()[0].strip()
            return re.sub(r"^[\w.-]+\s*[—:-]\s*", "", first)
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("#!"):
            continue
        if s.startswith("#"):
            return re.sub(r"^[\w.-]+\s*[—:-]\s*", "", s.lstrip("# ").strip())
    return ""


def collect_skills() -> list[dict]:
    out = []
    for d in sorted((ROOT / "skills").iterdir()):
        sk = d / "SKILL.md"
        if not d.is_dir() or d.name == "_template" or not sk.exists():
            continue
        fm = _frontmatter(sk.read_text(encoding="utf-8"))
        out.append({
            "name": fm.get("name", d.name),
            "file": str(sk.relative_to(ROOT)),
            "description": fm.get("description", ""),
        })
    return out


def collect_frontmatter_md(folder: str, use_name: bool) -> list[dict]:
    out = []
    for p in sorted((ROOT / folder).glob("*.md")):
        if _is_template(p):
            continue
        fm = _frontmatter(p.read_text(encoding="utf-8"))
        item = {"name": fm.get("name", p.stem) if use_name else p.stem,
                "file": str(p.relative_to(ROOT)),
                "description": fm.get("description", "")}
        out.append(item)
    return out


def collect_text_md(folder: str, prompt_style: bool = False) -> list[dict]:
    out = []
    for p in sorted((ROOT / folder).glob("*.md")):
        if _is_template(p):
            continue
        text = p.read_text(encoding="utf-8")
        desc = _prompt_desc(text) if prompt_style else _first_paragraph(text)
        out.append({"name": p.stem,
                    "file": str(p.relative_to(ROOT)),
                    "description": desc})
    return out


def collect_scripts() -> list[dict]:
    out = []
    for p in sorted((ROOT / "scripts").glob("*")):
        if p.name.startswith("_template") or not p.is_file():
            continue
        if p.suffix not in (".sh", ".py"):
            continue
        out.append({"name": p.stem,
                    "file": str(p.relative_to(ROOT)),
                    "description": _script_desc(p, p.read_text(encoding="utf-8"))})
    return out


def build(existing: dict) -> dict:
    cats = existing["categories"]
    cats["skills"]["items"] = collect_skills()
    cats["agents"]["items"] = collect_frontmatter_md("agents", use_name=True)
    cats["commands"]["items"] = collect_frontmatter_md("commands", use_name=False)
    cats["prompts"]["items"] = collect_text_md("prompts", prompt_style=True)
    cats["docs"]["items"] = collect_text_md("docs")
    cats["scripts"]["items"] = collect_scripts()
    existing["updated"] = _dt.date.today().isoformat()
    return existing


def main() -> int:
    check = "--check" in sys.argv
    existing = json.loads(CATALOG.read_text(encoding="utf-8"))
    rebuilt = build(json.loads(json.dumps(existing)))
    new_text = json.dumps(rebuilt, ensure_ascii=False, indent=2) + "\n"
    if check:
        cur = CATALOG.read_text(encoding="utf-8")
        # сравниваем только items, дату игнорируем
        a = json.loads(cur); b = json.loads(new_text)
        a.pop("updated", None); b.pop("updated", None)
        if a != b:
            print("catalog.json устарел — запусти scripts/build-catalog.py")
            return 1
        print("catalog.json актуален")
        return 0
    CATALOG.write_text(new_text, encoding="utf-8")
    total = sum(len(c["items"]) for c in rebuilt["categories"].values())
    print(f"catalog.json пересобран: {total} элементов")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
