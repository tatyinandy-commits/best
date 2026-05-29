#!/usr/bin/env bash
# Hook: auto-format (PostToolUse — Edit|Write)
# Автоматически форматирует только что отредактированный файл подходящим
# форматтером. Молча пропускает, если форматтер недоступен.
# Конфигурация в settings.json:
#   "PostToolUse": [{"matcher":"Edit|Write|MultiEdit","hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/auto-format.sh"}]}]
set -euo pipefail

event="$(cat)"
path="$(printf '%s' "$event" | python3 -c "import sys,json;print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || true)"

[[ -z "$path" || ! -f "$path" ]] && exit 0

case "$path" in
  *.py)
    command -v ruff   &>/dev/null && ruff format "$path"   &>/dev/null || true
    command -v black  &>/dev/null && black -q "$path"      &>/dev/null || true
    ;;
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md)
    command -v prettier &>/dev/null && prettier --write "$path" &>/dev/null \
      || npx --no-install prettier --write "$path" &>/dev/null || true
    ;;
  *.go)
    command -v gofmt &>/dev/null && gofmt -w "$path" &>/dev/null || true
    ;;
  *.rs)
    command -v rustfmt &>/dev/null && rustfmt "$path" &>/dev/null || true
    ;;
  *.sh)
    command -v shfmt &>/dev/null && shfmt -w "$path" &>/dev/null || true
    ;;
esac

exit 0
