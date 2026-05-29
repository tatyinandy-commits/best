---
name: json-wrangler
description: >-
  Use when the user wants to query, filter, reshape, or validate JSON data —
  building jq expressions or extracting fields from API responses. Not for
  designing JSON schemas from scratch.
---

# json-wrangler

## Назначение

Запросы и трансформации JSON с помощью `jq`.

## Когда использовать

- Достать/переформатировать поля из JSON (ответ API, конфиг, лог в JSON).
- Отфильтровать, отсортировать, агрегировать массив объектов.

## Рецепты

- Поле: `jq '.user.name' file.json`
- Массив объектов → выбрать поля: `jq '.items[] | {id, name}'`
- Фильтр: `jq '.items[] | select(.active == true)'`
- Преобразовать в CSV: `jq -r '.items[] | [.id, .name] | @csv'`
- Агрегация: `jq '[.items[].price] | add'`
- Валидация (только проверка парсинга): `jq empty file.json && echo ok`

## Шаги

1. Посмотри структуру: `jq 'keys'` или `jq '.[0]'`.
2. Строй выражение инкрементально, проверяя на части данных.
3. Для вывода без кавычек используй `-r`.

## Заметки

Проверь наличие `jq`. Для огромных файлов используй потоковый режим
(`jq --stream`).
