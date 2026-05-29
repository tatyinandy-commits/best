---
description: Добавляет правильный парсинг аргументов в bash-скрипт с --help, --dry-run и т.п.
---

# parse-args

Добавь парсинг аргументов командной строки к скрипту из `$ARGUMENTS`.

## Шаги

1. Прочитай скрипт и определи, какие аргументы ему нужны (обязательные,
   опциональные, флаги).
2. Реализуй парсинг через `while getopts` (короткие флаги) или ручной `while`-цикл
   для длинных опций (`--flag`).
3. Обязательно добавь:
   - `--help` / `-h` — вывод usage и выход с 0.
   - Валидацию обязательных аргументов с понятными сообщениями об ошибках.
   - `--dry-run` если скрипт производит изменения.
4. Usage-строка: `Usage: scriptname [OPTIONS] <required-arg>`.

## Шаблон (bash, длинные опции)

```bash
DRY_RUN=false; VERBOSE=false
usage() { echo "Usage: $0 [--dry-run] [--verbose] <target>"; exit "${1:-0}"; }
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true ;;
    --verbose)  VERBOSE=true ;;
    -h|--help)  usage 0 ;;
    -*)         echo "Unknown: $1" >&2; usage 1 ;;
    *)          TARGET="$1" ;;
  esac; shift
done
[[ -z "${TARGET:-}" ]] && { echo "Error: target required" >&2; usage 1; }
```

## Результат

Обновлённый скрипт с полным парсингом аргументов.
