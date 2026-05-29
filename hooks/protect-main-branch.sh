#!/usr/bin/env bash
# Hook: protect-main-branch (PreToolUse — Bash)
# Не даёт коммитить и пушить напрямую в main/master — заставляет работать в ветке.
# Конфигурация в settings.json:
#   "PreToolUse": [{"matcher":"Bash","hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/protect-main-branch.sh"}]}]
#
# exit 2 + stderr → блокирует вызов и возвращает причину модели.
set -euo pipefail

event="$(cat)"
cmd="$(printf '%s' "$event" | python3 -c "import sys,json;print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || true)"

# Интересуют только git commit / git push
printf '%s' "$cmd" | grep -Eq '\bgit\s+(commit|push)\b' || exit 0

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')"

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Заблокировано: попытка $cmd на защищённой ветке '$branch'." >&2
  echo "Создай feature-ветку: git checkout -b <feature-branch>." >&2
  exit 2
fi

exit 0
