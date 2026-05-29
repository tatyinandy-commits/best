---
name: env-diff
description: >-
  Use when the user wants to compare environment configurations across envs
  (dev/staging/prod) — finding missing variables, value mismatches, or
  undocumented keys. Not for managing secrets storage.
---

# env-diff

## Назначение

Сравнение `.env`-файлов между окружениями: что пропущено, что отличается.

## Шаги

1. Собери файлы: `.env`, `.env.example`, `.env.staging`, `.env.production`.
2. Извлеки ключи (без значений для безопасности):
   ```bash
   grep -v '^#' .env.example | cut -d= -f1 | sort > keys_example.txt
   grep -v '^#' .env         | cut -d= -f1 | sort > keys_actual.txt
   diff keys_example.txt keys_actual.txt
   ```
3. Найди: ключи в `.env.example` без значения в `.env` (переменные не задан),
   ключи в `.env` без документирования в `.env.example`.
4. Проверь типичные расхождения prod/staging: разные базы, разные уровни логирования.

## Формат вывода

- Пропущенные переменные (есть в example, нет в файле).
- Задокументированные (есть в файле, нет в example).
- Расхождения между окружениями (только ключи, без значений).

## Заметки

Никогда не выводи реальные значения секретов.
