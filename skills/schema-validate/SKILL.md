---
name: schema-validate
description: >-
  Use when the user wants to validate data against a JSON Schema, Zod, Pydantic,
  or similar schema — checking conformance, generating test fixtures, or
  identifying schema gaps. Not for designing the schema itself.
---

# schema-validate

## Назначение

Валидация данных по схеме и выявление несоответствий.

## Инструменты

- JSON Schema: `npx ajv-cli validate -s schema.json -d data.json`
- Python/Pydantic: `python3 -c "from model import MyModel; MyModel.parse_file('data.json')"`
- Zod (TS): `schema.parse(data)` — выдаст ZodError с путями несоответствий.

## Шаги

1. Определи схему и данные.
2. Запусти валидатор; собери ошибки.
3. Сгруппируй по пути: `data.items[2].price` → «отсутствует поле / неверный тип».
4. Выдели паттерны: одна и та же ошибка повторяется? Значит, схема или данные
   систематически расходятся.
5. Если нужно — предложи фикс схемы или данных.

## Формат вывода

Список ошибок: путь | ожидаемый тип | полученное значение.
Резюме: N ошибок в M объектах.
