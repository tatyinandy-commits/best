---
name: git-history-clean
description: >-
  Use when the user wants to clean up a messy branch before merging — squashing
  fixup commits, reordering, splitting, or rewriting messages with interactive
  rebase. Not for rewriting shared/published history.
---

# git-history-clean

## Назначение

Приведение истории ветки в порядок перед мёржем через интерактивный rebase.

## Когда использовать

- В ветке много WIP/fixup-коммитов, которые нужно объединить.
- Нужно переупорядочить коммиты для логичного повествования.
- Сообщения коммитов не соответствуют стандарту проекта.

## Когда НЕ использовать

- Ветка опубликована и другие разработчики на неё ориентируются (публичная история).

## Шаги

1. Найди базу: `git merge-base HEAD main` или `git log --oneline main..HEAD`.
2. Начни rebase: `git rebase -i <base-sha>`.
3. В редакторе:
   - `pick` — оставить как есть.
   - `squash`/`s` — объединить с предыдущим, сохранить сообщение.
   - `fixup`/`f` — объединить, выбросить сообщение.
   - `reword`/`r` — изменить только сообщение.
   - `drop`/`d` — удалить коммит.
4. Разрешай конфликты по ходу: `git rebase --continue` после каждого.
5. Проверь результат: `git log --oneline`, запусти тесты.

## Заметки

Имей запасную ветку на случай ошибки: `git branch backup-before-rebase`.
Отменить: `git rebase --abort` в процессе, или `git reset --hard ORIG_HEAD` после.
