#!/usr/bin/env bash
# Hook: post-tool-logger (PostToolUse)
# Логирует вызовы инструментов в файл для аудита и отладки сессии.
# Конфигурация в settings.json:
#   "PostToolUse": [{"hooks": [{"type": "command", "command": "./hooks/post-tool-logger.sh"}]}]
set -euo pipefail

LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/tool-calls-$(date +%Y%m%d).jsonl"

event="$(cat)"

# Добавляем timestamp и пишем как JSONL
printf '%s' "$event" \
  | python3 -c "
import sys, json, datetime
e = json.load(sys.stdin)
e['_logged_at'] = datetime.datetime.utcnow().isoformat() + 'Z'
print(json.dumps(e, ensure_ascii=False))
" >> "$LOG_FILE" 2>/dev/null || true

exit 0
