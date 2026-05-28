---
name: dependency-audit
description: >-
  Use when the user wants to audit project dependencies for known
  vulnerabilities, outdated versions, or unused packages — across npm, pip,
  cargo, or go modules. Not for adding new dependencies.
---

# dependency-audit

## Назначение

Проверка зависимостей проекта на уязвимости, устаревание и неиспользуемые пакеты.

## Когда использовать

- Запрос на security/health-аудит зависимостей.
- Подготовка к обновлению зависимостей.

## Шаги

1. Определи менеджер пакетов по lock-файлу (`package-lock.json`, `poetry.lock`,
   `Cargo.lock`, `go.sum`).
2. Уязвимости:
   - npm: `npm audit --json`
   - pip: `pip-audit`
   - cargo: `cargo audit`
   - go: `govulncheck ./...`
3. Устаревшие: `npm outdated`, `pip list --outdated`, `cargo outdated`.
4. Неиспользуемые (опционально): `depcheck` (npm), `deptry` (python).
5. Сведи отчёт: severity, текущая → безопасная версия, рекомендация.

## Формат вывода

Таблица: пакет | проблема | severity | текущая | рекомендуемая | действие.

## Заметки

- Не применяй обновления без подтверждения — только отчёт и план.
- Разделяй прямые и транзитивные зависимости.
