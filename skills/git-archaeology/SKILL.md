---
name: git-archaeology
description: >-
  Use when the user wants to understand why code looks the way it does —
  who changed it, why, when, and whether there are related commits or issues.
  Good for understanding intent before refactoring or fixing.
---

# git-archaeology

## Назначение

Исследование истории изменений конкретного кода: кто, когда, зачем.

## Инструменты

```bash
# Кто менял строки файла
git blame -L 10,30 path/to/file.py

# История конкретного файла
git log --follow --oneline -- path/to/file.py

# Diff конкретного коммита
git show <sha>

# Поиск по сообщениям коммитов
git log --oneline --all --grep="search term"

# Поиск по коду (когда строка появилась/исчезла)
git log -S 'function_name' --source --all

# Все коммиты, касавшиеся функции
git log -L :function_name:path/to/file.py
```

## Шаги

1. `git blame` — найди коммит, добавивший интересный код.
2. `git show <sha>` — посмотри полный контекст изменения.
3. `git log --grep` — найди связанные коммиты/тикеты в сообщениях.
4. Проследи историю файла через переименования (`--follow`).

## Заметки

Сообщения коммитов часто содержат ссылки на issue-трекер (JIRA-123, #42).
