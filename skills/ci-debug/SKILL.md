---
name: ci-debug
description: >-
  Use when a CI/CD run is failing and the user wants the root cause found and
  fixed — parsing CI logs, identifying the first failure, and suggesting or
  applying a fix. Not for designing CI pipelines from scratch.
---

# ci-debug

## Назначение

Разбор упавшего CI-прогона и локализация первопричины сбоя.

## Шаги

1. Получи логи: из вывода инструмента, файла или ссылки.
2. Найди первую ошибку (не всегда последняя строка): ищи `error:`, `FAILED`,
   `Error`, `exit code`, `npm ERR!`, `Traceback`, `fatal:`.
3. Определи тип:
   - Тест: какой тест, что ожидалось, что пришло.
   - Зависимости: версия, конфликт, сеть.
   - Синтаксис/типы: файл и строка.
   - Env/секрет: не задана переменная, неверный credential.
   - Ресурс: OOM, дисковое пространство, таймаут.
4. Предложи минимальный фикс; для тестов — сначала воспроизведи локально.

## Формат вывода

Первопричина (1–2 строки) → цитата из лога → предлагаемый фикс.
