---
name: docker-compose-check
description: >-
  Use when the user wants a docker-compose.yml reviewed — checking service
  health checks, dependency ordering, volume mounts, port conflicts, and
  production-readiness issues. Not for writing compose from scratch.
---

# docker-compose-check

## Назначение

Ревью `docker-compose.yml` на корректность и готовность к использованию.

## На что смотреть

- **Порядок запуска:** `depends_on` задан? С `condition: service_healthy` если нужно.
- **Health checks:** у critical-сервисов есть `healthcheck`?
- **Тома:** named volumes вместо анонимных; пути хоста явные.
- **Порты:** нет конфликтов; production не экспортирует лишнего.
- **Секреты:** нет паролей в `environment` — используй `secrets` или env-файл.
- **Перезапуск:** `restart: unless-stopped` для prod, `no` для CI.
- **Ресурсы:** `mem_limit`/`cpus` для production-критичных сервисов.

## Шаги

1. Проверь синтаксис: `docker compose config`.
2. Пройди по чек-листу выше.
3. Выяви потенциальные проблемы запуска (race conditions, отсутствие healthcheck).

## Формат вывода

Список находок с severity + исправленные фрагменты YAML.
