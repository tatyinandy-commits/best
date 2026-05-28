---
name: git-bisect-run
description: >-
  Use when the user wants to find the commit that introduced a bug using
  git bisect — ideally automated with a test command. Not for reverting or
  cherry-picking commits.
---

# git-bisect-run

## Назначение

Поиск коммита, в котором появился баг, бинарным поиском по истории.

## Когда использовать

- Известно «раньше работало, сейчас нет», есть хороший и плохой коммит.
- Есть команда/тест, отличающая «хорошо» от «плохо».

## Шаги

1. Запусти бисект: `git bisect start`.
2. Помечай границы: `git bisect bad <плохой>` и `git bisect good <хороший>`.
3. Автоматизируй: `git bisect run <команда>` — exit 0 = good, 1–124 = bad,
   125 = skip (не тестируется).
4. Git выдаст «<sha> is the first bad commit». Изучи его diff.
5. Заверши: `git bisect reset`.

## Заметки

- Тест-команда должна быть детерминированной и быстрой.
- Для нетестируемых ревизий используй `git bisect skip`.
- Полезно завернуть проверку в небольшой скрипт с явным кодом возврата.
