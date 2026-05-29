#!/usr/bin/env bash
# Hook: block-dangerous-commands (PreToolUse — Bash)
# Блокирует заведомо разрушительные shell-команды до их выполнения.
# Конфигурация в settings.json:
#   "PreToolUse": [{"matcher":"Bash","hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/block-dangerous-commands.sh"}]}]
#
# exit 2 + stderr → блокирует вызов и возвращает причину модели.
set -euo pipefail

event="$(cat)"
cmd="$(printf '%s' "$event" | python3 -c "import sys,json;print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || true)"

# Паттерны разрушительных команд (расширяй под свои нужды)
patterns=(
  'rm[[:space:]]+-rf?[[:space:]]+/($|[[:space:]])'   # rm -rf /
  'rm[[:space:]]+-rf?[[:space:]]+~($|/[[:space:]]?)' # rm -rf ~
  ':\(\)\s*\{.*\}\s*;:'                              # fork bomb
  'mkfs\.'                                           # форматирование ФС
  'dd[[:space:]]+if=.*of=/dev/(sd|nvme|disk)'        # перезапись диска
  '>[[:space:]]*/dev/(sd|nvme|disk)'                 # запись в блочное устройство
  'chmod[[:space:]]+-R?[[:space:]]*777[[:space:]]+/' # chmod 777 на корень
  'git[[:space:]]+push.*--force.*\b(main|master)\b'  # force push в main
)

for p in "${patterns[@]}"; do
  if printf '%s' "$cmd" | grep -Eq "$p"; then
    echo "Заблокировано: команда совпала с разрушительным паттерном ($p)." >&2
    echo "Если это намеренно — выполни вручную вне Claude Code." >&2
    exit 2
  fi
done

exit 0
