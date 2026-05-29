#!/usr/bin/env bash
# Hook: inject-context (UserPromptSubmit)
# Добавляет в контекст сессии актуальную информацию (ветка, незакоммиченные
# изменения), чтобы модель учитывала состояние репозитория.
# Конфигурация в settings.json:
#   "UserPromptSubmit": [{"hooks":[{"type":"command",
#     "command":"$CLAUDE_PROJECT_DIR/hooks/inject-context.sh"}]}]
#
# stdout добавляется к контексту модели.
set -euo pipefail

cat >/dev/null  # промпт нам не нужен

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'n/a')"
dirty="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

echo "[repo-context] ветка: ${branch}; незакоммиченных файлов: ${dirty}"

# Предупреждение, если на защищённой ветке
if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "[repo-context] ВНИМАНИЕ: ты на защищённой ветке '$branch' — создай feature-ветку перед коммитом."
fi

exit 0
