---
description: Запускает tail с фильтром по уровню/паттерну и форматирует вывод.
---

# watch-logs

Наблюдай за логами в реальном времени. Файл/команда и фильтр из `$ARGUMENTS`.

## Шаги

1. Определи источник из аргументов: путь к файлу или команда (journalctl, docker logs).
2. Выбери режим:
   - Файл: `tail -f <file> | grep --line-buffered -E '<pattern>'`
   - Docker: `docker logs -f <container> 2>&1 | grep --line-buffered -E '<pattern>'`
   - Journalctl: `journalctl -f -u <service> | grep --line-buffered -E '<pattern>'`
3. Паттерн по умолчанию: `ERROR|WARN|FATAL|Exception|panic`.
4. Запусти и наблюдай; объясни значимые строки если попросят.

## Результат

Поток строк из лога с выделением ошибок. Объяснение по запросу.
