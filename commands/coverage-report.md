---
description: Запускает тесты с покрытием и суммирует незакрытые строки по файлам.
---

# coverage-report

Запусти тесты с покрытием и покажи где оно низкое.

## Шаги

1. Определи инструмент:
   - Python: `pytest --cov=. --cov-report=term-missing`
   - Node/TS: `npx jest --coverage` или `npx vitest --coverage`
   - Go: `go test ./... -coverprofile=coverage.out && go tool cover -func=coverage.out`
   - Rust: `cargo tarpaulin`
2. Запусти и собери отчёт.
3. Отсортируй файлы по покрытию (снизу вверх).
4. Для файлов < 60% — выдели незакрытые строки/ветки.

Цель из `$ARGUMENTS` (файл/пакет) или весь проект.

## Результат

Таблица: файл | % покрытия | незакрытые строки. Топ-5 файлов с наименьшим покрытием.
