#!/usr/bin/env bash
# Hook: webhook-notify (Stop | Notification)
# Отправляет уведомление о завершении хода в Slack/Discord/произвольный webhook.
# Требует переменную окружения WEBHOOK_URL.
# Конфигурация в settings.json:
#   "Stop": [{"hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/webhook-notify.sh"}]}]
set -euo pipefail

cat >/dev/null  # событие не используем

: "${WEBHOOK_URL:=}"
[[ -z "$WEBHOOK_URL" ]] && exit 0   # не настроено — тихо выходим

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'n/a')"
repo="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
text="Claude Code завершил ход — repo: ${repo}, ветка: ${branch}, $(date +%H:%M)"

# Формат Slack/Discord-совместимый ({"text": "..."}).
curl -fsS -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d "$(python3 -c "import json,sys;print(json.dumps({'text': sys.argv[1]}))" "$text")" \
  &>/dev/null || true

exit 0
