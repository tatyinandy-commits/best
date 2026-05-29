---
name: mock-data-gen
description: >-
  Use when the user needs realistic mock/fixture data for tests, demos, or
  local development — generating JSON, SQL inserts, or CSV matching a given
  schema or example. Not for generating production data.
---

# mock-data-gen

## Назначение

Генерация реалистичных тестовых данных под схему или пример.

## Инструменты

- **faker.js / @faker-js/faker** (Node):
  ```js
  import { faker } from '@faker-js/faker';
  faker.person.fullName(); faker.internet.email(); faker.date.past();
  ```
- **Faker (Python)**:
  ```python
  from faker import Faker; fake = Faker()
  fake.name(), fake.email(), fake.address()
  ```
- **factory_boy** (Python) — фабрики для ORM-моделей.
- **Без зависимостей** — сгенерирую статичный JSON/CSV под схему вручную.

## Шаги

1. Получи схему (JSON Schema, Pydantic-модель, SQL DDL) или пример данных.
2. Определи нужный формат и количество записей.
3. Для чувствительных полей (email, телефон) — явно фейковые значения
   (example.com, +1-555-XXX).
4. Сгенерируй данные.

## Формат вывода

Готовые данные в запрошенном формате + скрипт-генератор если нужен повторный запуск.
