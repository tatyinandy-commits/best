#!/usr/bin/env bash
# Hook: notify-on-stop (Stop)
# Шлёт системное уведомление, когда ассистент завершает ход — удобно для
# долгих задач, когда отвлёкся от терминала.
# Конфигурация в settings.json:
#   "Stop": [{"hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/notify-on-stop.sh"}]}]
set -euo pipefail

cat >/dev/null  # событие нам не нужно, просто поглощаем stdin

title="Claude Code"
msg="Задача завершена ($(date +%H:%M))"

if command -v notify-send &>/dev/null; then          # Linux
  notify-send "$title" "$msg" || true
elif command -v osascript &>/dev/null; then           # macOS
  osascript -e "display notification \"$msg\" with title \"$title\"" || true
elif command -v tput &>/dev/null; then                # терминальный звонок
  printf '\a'
fi

exit 0
