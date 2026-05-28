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


def _first_text_line(text: str, skip_heading: bool = True) -> str:
    for line in text.splitlines():
        s = line.strip()
        if not s:
            continue
        if skip_heading and s.startswith("#"):
            continue
        if s.startswith(">"):
            s = s.lstrip("> ").strip()
            s = re.sub(r"^Назначение:\s*", "", s)
        return s
    return ""


def _comment_desc(text: str) -> str:
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("#!"):
            continue
        if s.startswith("#"):
            s = s.lstrip("# ").strip()
            return re.sub(r"^[\w.-]+\s*[—:-]\s*", "", s)
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


def collect_text_md(folder: str) -> list[dict]:
    out = []
    for p in sorted((ROOT / folder).glob("*.md")):
        if _is_template(p):
            continue
        out.append({"name": p.stem,
                    "file": str(p.relative_to(ROOT)),
                    "description": _first_text_line(p.read_text(encoding="utf-8"))})
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
                    "description": _comment_desc(p.read_text(encoding="utf-8"))})
    return out


def build(existing: dict) -> dict:
    cats = existing["categories"]
    cats["skills"]["items"] = collect_skills()
    cats["agents"]["items"] = collect_frontmatter_md("agents", use_name=True)
    cats["commands"]["items"] = collect_frontmatter_md("commands", use_name=False)
    cats["prompts"]["items"] = collect_text_md("prompts")
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
