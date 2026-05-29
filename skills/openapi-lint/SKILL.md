---
name: openapi-lint
description: >-
  Use when the user has an OpenAPI/Swagger spec (YAML or JSON) and wants it
  validated for correctness, consistency, and common API design issues —
  missing descriptions, broken refs, inconsistent error schemas. Not for
  generating an OpenAPI spec from scratch.
---

# openapi-lint

## Назначение

Валидация и проверка качества OpenAPI/Swagger спецификации.

## Когда использовать

- Spec нужно проверить на соответствие стандарту и best practices.
- Перед публикацией API или настройкой кодогенерации.

## Шаги

1. Проверь наличие инструментов: `npx @redocly/cli lint openapi.yaml` или
   `npx @stoplight/spectral-cli lint openapi.yaml`.
2. Без инструментов — ручная проверка:
   - Все `$ref` разрешаются?
   - Каждый путь имеет `summary`/`description`?
   - Есть ответы на ошибки (400/401/404/500)?
   - Схемы запроса/ответа определены, не пустые?
   - Параметры пути объявлены?
   - `operationId` уникальны?
3. Проверь на Breaking Changes: `oasdiff diff old.yaml new.yaml`.

## Формат вывода

Список проблем: путь/операция | тип проблемы | рекомендация. Severity: error/warning/info.
