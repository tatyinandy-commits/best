---
name: csv-transform
description: >-
  Use when the user wants to filter, reshape, join, or aggregate CSV/TSV data
  from the command line — slicing columns, computing stats, converting formats.
  Not for large-scale data pipelines (use a proper data tool for millions of rows).
---

# csv-transform

## Назначение

Трансформации CSV/TSV данных прямо в терминале.

## Инструменты и рецепты

### csvkit (pip install csvkit)
- Просмотр схемы: `csvstat data.csv`
- Срез колонок: `csvcut -c id,name,email data.csv`
- Фильтр строк: `csvgrep -c status -m active data.csv`
- Объединение файлов: `csvstack a.csv b.csv`
- SQL по CSV: `csvsql --query 'SELECT * FROM data WHERE age > 30' data.csv`

### miller (mlr)
- Переименовать колонку: `mlr --csv rename old_name,new_name data.csv`
- Вычислить поле: `mlr --csv put '$total = $qty * $price' data.csv`
- Группировка: `mlr --csv stats1 -a mean,count -f price -g category data.csv`

### awk / paste (без зависимостей)
- Срез колонки: `awk -F, '{print $1,$3}' OFS=, data.csv`
- Посчитать строки: `awk -F, 'NR>1{sum+=$3} END{print sum}' data.csv`

## Шаги

1. Определи задачу (фильтр, агрегат, join, конвертация).
2. Выбери инструмент по доступности; предложи установку если нет.
3. Выполни и покажи первые строки результата.
