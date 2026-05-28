---
name: i18n-extract
description: >-
  Use when the user wants to extract hardcoded strings from UI code for
  internationalization — finding untranslated literals, wrapping them in i18n
  calls, and generating translation keys. Not for translating content.
---

# i18n-extract

## Назначение

Поиск захардкоженных строк в UI-коде и подготовка к интернационализации.

## Когда использовать

- Нужно найти незернализованные строки в JSX/TSX/Vue/шаблонах.
- Подготовка к добавлению нового языка.

## Шаги

1. Найди строки-кандидаты:
   ```bash
   grep -rn --include='*.tsx' --include='*.jsx' \
     -E '>[A-Za-zА-Яа-я][^<{]{2,}<' src/
   ```
2. Исключи: технические строки (CSS-классы, ID, console.log), значения атрибутов
   `data-*`, `aria-*` без видимого текста.
3. Для каждой строки: предложи ключ `section.component.descriptor` и замену на
   `t('ключ')` / `i18n.t('ключ')`.
4. Обнови файл переводов (`en.json` / `messages.js`) новыми парами ключ→строка.

## Формат вывода

Таблица: файл:строка | оригинальная строка | предлагаемый ключ | замена.
Блок с новыми записями для файла переводов.
