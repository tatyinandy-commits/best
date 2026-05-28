#!/usr/bin/env bash
# Hook: TEMPLATE_NAME
# Описание: что делает хук и на каком событии срабатывает.
#
# Claude Code передаёт событие как JSON в stdin. Управляющий вывод —
# через stdout/stderr и код возврата:
#   exit 0 — успех (stdout может быть показан модели/пользователю)
#   exit 2 — блокирующая ошибка (stderr возвращается модели)
set -euo pipefail

# Прочитать событие из stdin (требует jq).
event="$(cat)"

# Пример: достать поле из события.
# tool_name="$(printf '%s' "$event" | jq -r '.tool_name // empty')"

# --- логика хука ---

echo "TEMPLATE_NAME hook executed"
exit 0
