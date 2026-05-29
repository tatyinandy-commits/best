#!/usr/bin/env bash
# Hook: session-start
# Запускается при старте сессии Claude Code. Проверяет здоровье окружения:
# наличие зависимостей, доступность ключевых утилит, не сломан ли lock-файл.
# exit 0 — всё OK; вывод stdout виден модели как контекст.
set -euo pipefail

ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel 2>/dev/null || pwd)"

issues=()

# --- проверка lock-файла / менеджера пакетов ---
if [[ -f "$ROOT/package.json" ]]; then
  if ! command -v node &>/dev/null; then
    issues+=("node не найден")
  elif [[ -f "$ROOT/package-lock.json" ]] && ! npm ls --prefix "$ROOT" &>/dev/null; then
    issues+=("npm deps устарели — запусти npm install")
  fi
fi
if [[ -f "$ROOT/pyproject.toml" ]] || [[ -f "$ROOT/requirements.txt" ]]; then
  if ! command -v python3 &>/dev/null; then
    issues+=("python3 не найден")
  fi
fi

# --- git статус ---
if git -C "$ROOT" status --porcelain | grep -q '^UU'; then
  issues+=("есть конфликты слияния в рабочем дереве")
fi

# --- отчёт ---
if [[ ${#issues[@]} -eq 0 ]]; then
  echo "session-start: окружение OK ($(date +%H:%M))"
else
  echo "session-start: внимание:"
  for i in "${issues[@]}"; do echo "  - $i"; done
fi
exit 0
