#!/usr/bin/env bash
# install.sh — подключает элементы коллекции в целевой проект (для Claude Code).
#
# Claude Code читает скиллы/агентов/команды из каталога .claude/ проекта
# (или из ~/.claude/ для пользовательского уровня). Этот скрипт раскладывает
# элементы коллекции туда симлинками (по умолчанию) или копиями.
#
# Использование:
#   ./scripts/install.sh <target-project-dir> [--copy] [--user]
#
#   <target-project-dir>  корень проекта, куда ставим (например, ваш Forgejo-репо)
#   --copy                копировать файлы вместо симлинков (для submodule не нужно)
#   --user                ставить в ~/.claude вместо <target>/.claude
#
# После установки скрипт печатает готовые сниппеты для hooks (settings.json)
# и MCP (.mcp.json) — их нужно вставить вручную (осознанно, не на все подряд).
set -euo pipefail

COLLECTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COPY=false
USER_LEVEL=false
TARGET=""

usage() { echo "Usage: $0 <target-project-dir> [--copy] [--user]"; exit "${1:-0}"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) COPY=true ;;
    --user) USER_LEVEL=true ;;
    -h|--help) usage 0 ;;
    -*) echo "Unknown option: $1" >&2; usage 1 ;;
    *)  TARGET="$1" ;;
  esac; shift
done

if $USER_LEVEL; then
  DEST="$HOME/.claude"
else
  [[ -z "$TARGET" ]] && { echo "Error: укажи каталог проекта" >&2; usage 1; }
  [[ -d "$TARGET" ]] || { echo "Error: '$TARGET' не существует" >&2; exit 1; }
  DEST="$(cd "$TARGET" && pwd)/.claude"
fi

link_or_copy() {
  local src="$1" dst="$2"
  rm -rf "$dst"
  if $COPY; then cp -r "$src" "$dst"; else ln -s "$src" "$dst"; fi
}

echo "Коллекция: $COLLECTION_DIR"
echo "Назначение: $DEST"
echo "Режим: $([[ $COPY == true ]] && echo копирование || echo симлинки)"
echo

# --- skills (папки с SKILL.md) ---
mkdir -p "$DEST/skills"
n=0
for d in "$COLLECTION_DIR"/skills/*/; do
  name="$(basename "$d")"
  [[ "$name" == "_template" ]] && continue
  [[ -f "$d/SKILL.md" ]] || continue
  link_or_copy "$d" "$DEST/skills/$name"
  n=$((n+1))
done
echo "skills:   $n"

# --- agents (файлы .md) ---
mkdir -p "$DEST/agents"
n=0
for f in "$COLLECTION_DIR"/agents/*.md; do
  base="$(basename "$f")"
  [[ "$base" == "_template.md" || "$base" == "README.md" ]] && continue
  link_or_copy "$f" "$DEST/agents/$base"
  n=$((n+1))
done
echo "agents:   $n"

# --- commands (файлы .md) ---
mkdir -p "$DEST/commands"
n=0
for f in "$COLLECTION_DIR"/commands/*.md; do
  base="$(basename "$f")"
  [[ "$base" == "_template.md" || "$base" == "README.md" ]] && continue
  link_or_copy "$f" "$DEST/commands/$base"
  n=$((n+1))
done
echo "commands: $n"

echo
echo "Готово. Hooks и MCP подключаются осознанно — вставь нужные сниппеты:"
echo
echo "--- $DEST/settings.json (пример hooks) ---"
cat <<EOF
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [
        { "type": "command", "command": "$COLLECTION_DIR/hooks/block-dangerous-commands.sh" },
        { "type": "command", "command": "$COLLECTION_DIR/hooks/protect-main-branch.sh" }
      ]},
      { "matcher": "Edit|Write|MultiEdit", "hooks": [
        { "type": "command", "command": "$COLLECTION_DIR/hooks/protect-sensitive-files.sh" }
      ]}
    ]
  }
}
EOF
echo
echo "--- <project>/.mcp.json (пример) ---"
echo "Скопируй нужный конфиг из $COLLECTION_DIR/mcp/ и подставь свои \${ENV}."
