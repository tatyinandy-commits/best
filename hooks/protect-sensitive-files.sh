#!/usr/bin/env bash
# Hook: protect-sensitive-files (PreToolUse — Edit|Write)
# Запрещает изменение чувствительных файлов (секреты, ключи, prod-конфиги).
# Конфигурация в settings.json:
#   "PreToolUse": [{"matcher":"Edit|Write|MultiEdit","hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/protect-sensitive-files.sh"}]}]
#
# exit 2 + stderr → блокирует правку и возвращает причину модели.
set -euo pipefail

event="$(cat)"
path="$(printf '%s' "$event" | python3 -c "import sys,json;print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || true)"

[[ -z "$path" ]] && exit 0

# Защищённые паттерны путей
protected=(
  '\.env($|\.)'           # .env, .env.production
  '\.pem$'                # приватные ключи
  '\.key$'
  'id_rsa'
  'credentials'
  'secrets?\.(ya?ml|json|toml)$'
  '\.aws/'
  '\.ssh/'
)

base="$(basename "$path")"
for p in "${protected[@]}"; do
  if printf '%s' "$path" | grep -Eq "$p"; then
    echo "Заблокировано: '$base' помечен как чувствительный файл ($p)." >&2
    echo "Редактируй секреты вручную и не коммить их в репозиторий." >&2
    exit 2
  fi
done

exit 0
