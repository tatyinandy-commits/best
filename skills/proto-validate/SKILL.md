---
name: proto-validate
description: >-
  Use when the user has Protocol Buffers (.proto) files and wants them checked
  — syntax, field numbering, breaking changes between versions, and buf lint
  best practices. Not for designing a gRPC service from scratch.
---

# proto-validate

## Назначение

Валидация `.proto` файлов на корректность и соблюдение best practices.

## Инструменты

```bash
# buf lint (рекомендуется)
buf lint                          # по buf.yaml
buf lint path/to/file.proto

# Breaking change detection
buf breaking --against '.git#branch=main'

# Форматирование
buf format --diff
buf format -w
```

## Чек-лист без инструментов

- Каждое поле имеет уникальный номер?
- Номера 1–15 у часто используемых полей (однобайтный encoding)?
- `reserved` для удалённых полей/номеров?
- `package` объявлен и соответствует пути файла?
- Каждый message/service/enum задокументированы?
- `optional` / `repeated` явно указаны?

## Breaking changes (никогда не делать)

- Изменить номер поля.
- Изменить тип поля.
- Переименовать поле (если используется JSON encoding).
- Удалить поле без `reserved`.

## Формат вывода

Список нарушений: файл:строка | правило | рекомендация.
