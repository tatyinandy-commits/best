#!/usr/bin/env bash
# Hook: pre-commit-lint (PreToolUse — Bash)
# Перехватывает вызовы git commit и запускает линтер/форматтер перед коммитом.
# Используй в hooks.PreToolUse для tool_name == "Bash" с проверкой команды.
#
# Claude Code передаёт событие как JSON в stdin:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }
# exit 2 + stderr = блокирует вызов инструмента и возвращает сообщение модели.
set -euo pipefail

event="$(cat)"
tool_name="$(printf '%s' "$event" | python3 -c "import sys,json;e=json.load(sys.stdin);print(e.get('tool_name',''))")"
command="$(printf '%s' "$event" | python3 -c "import sys,json;e=json.load(sys.stdin);print(e.get('tool_input',{}).get('command',''))")"

# Пропускаем не-git-commit команды
if [[ "$tool_name" != "Bash" ]] || ! printf '%s' "$command" | grep -qE '^\s*git\s+commit'; then
  exit 0
fi

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# npm / yarn — eslint + prettier check
if [[ -f "$ROOT/package.json" ]]; then
  if npx --no-install eslint --max-warnings=0 . 2>/dev/null; then
    :
  else
    echo "ESLint нашёл предупреждения/ошибки. Исправь перед коммитом." >&2
    exit 2
  fi
fi

# Python — ruff
if command -v ruff &>/dev/null && [[ -f "$ROOT/pyproject.toml" ]]; then
  if ! ruff check "$ROOT" --quiet; then
    echo "ruff нашёл ошибки. Запусти 'ruff check --fix'." >&2
    exit 2
  fi
fi

exit 0
