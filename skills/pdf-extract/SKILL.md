---
name: pdf-extract
description: >-
  Use when the user wants to pull text, tables, or metadata out of a PDF file —
  extracting content, converting a PDF to markdown/text, or scraping fields
  from invoices/reports. Not for generating or editing PDFs.
---

# pdf-extract

## Назначение

Извлечение текста, таблиц и метаданных из PDF-файлов для дальнейшей обработки.

## Когда использовать

- Нужно превратить PDF в текст/markdown.
- Нужно достать таблицы или конкретные поля (инвойсы, отчёты).
- Нужны метаданные (число страниц, автор, дата).

## Когда НЕ использовать

- Генерация или редактирование PDF.
- Сканы без текстового слоя без согласия на OCR.

## Шаги

1. Определи, есть ли текстовый слой: `pdftotext -layout file.pdf -` (часть poppler).
2. Для структуры используй `pdftotext -layout`; для таблиц — `camelot`/`tabula`
   (Python) при наличии.
3. Скан без текста → OCR: `ocrmypdf in.pdf out.pdf` затем извлечение текста.
4. Метаданные: `pdfinfo file.pdf`.
5. Верни результат в запрошенном формате (txt/markdown/CSV/JSON).

## Заметки

- Проверь доступность инструментов перед использованием; предложи установку,
  но не ставь без подтверждения.
- Большие PDF обрабатывай постранично (`-f`/`-l` у pdftotext).
