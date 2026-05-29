#!/usr/bin/env bash
# Hook: run-related-tests (PostToolUse — Edit|Write)
# После правки исходного файла находит и запускает связанный тест-файл.
# Результат (включая падения) уходит модели через stdout.
# Конфигурация в settings.json:
#   "PostToolUse": [{"matcher":"Edit|Write|MultiEdit","hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/run-related-tests.sh"}]}]
set -euo pipefail

event="$(cat)"
path="$(printf '%s' "$event" | python3 -c "import sys,json;print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || true)"

[[ -z "$path" || ! -f "$path" ]] && exit 0

dir="$(dirname "$path")"
base="$(basename "$path")"
stem="${base%.*}"

case "$path" in
  # Не запускаем тесты на тесты, конфиги и доки
  *test*|*spec*|*.md|*.json|*.yaml|*.yml) exit 0 ;;
  *.py)
    for cand in "$dir/test_${stem}.py" "$dir/${stem}_test.py" "tests/test_${stem}.py"; do
      if [[ -f "$cand" ]]; then
        echo "run-related-tests: pytest $cand"
        pytest "$cand" -q 2>&1 | tail -20 || true
        exit 0
      fi
    done
    ;;
  *.js|*.ts|*.jsx|*.tsx)
    for cand in "$dir/${stem}.test.${base##*.}" "$dir/${stem}.spec.${base##*.}"; do
      if [[ -f "$cand" ]]; then
        echo "run-related-tests: $cand"
        npx --no-install jest "$cand" 2>&1 | tail -20 || true
        exit 0
      fi
    done
    ;;
esac

exit 0
