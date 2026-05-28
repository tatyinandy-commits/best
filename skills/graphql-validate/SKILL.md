---
name: graphql-validate
description: >-
  Use when the user has a GraphQL schema or queries and wants them validated —
  syntax, type correctness, unused fields, N+1 patterns, or breaking changes
  between schema versions. Not for designing a GraphQL API from scratch.
---

# graphql-validate

## Назначение

Валидация GraphQL схемы и запросов на корректность и эффективность.

## Шаги

1. **Синтаксис схемы:**
   ```bash
   npx graphql-inspector validate schema.graphql
   # или
   node -e "require('graphql').buildSchema(require('fs').readFileSync('schema.graphql','utf8'))"
   ```
2. **Валидация запросов против схемы:**
   ```bash
   npx graphql-inspector validate 'src/**/*.graphql' --schema schema.graphql
   ```
3. **Breaking changes:**
   ```bash
   npx graphql-inspector diff old-schema.graphql new-schema.graphql
   ```
4. **N+1 паттерны:** ищи запросы, которые запрашивают поля связей без DataLoader.
5. **Unused fields:** поля схемы, которые никогда не запрашиваются.

## На что смотреть

- Типы с `!` (non-null) — не сломают ли клиентов?
- Нет ли циклических зависимостей в типах без pagination?
- `ID` поля везде где нужна идентификация.

## Формат вывода

Список проблем: тип/поле | категория | severity | рекомендация.
