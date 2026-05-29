---
name: dockerfile-review
description: >-
  Use when the user wants a Dockerfile reviewed or slimmed — reducing image
  size, improving layer caching, and fixing security issues. Not for authoring
  Kubernetes manifests or compose orchestration.
---

# dockerfile-review

## Назначение

Ревью Dockerfile: размер образа, кэширование слоёв, безопасность.

## На что смотреть

- **Размер:** multi-stage build, минимальный базовый образ (slim/alpine/distroless),
  очистка кэша пакетного менеджера в том же слое.
- **Кэш слоёв:** копируй манифесты зависимостей и ставь их ДО копирования кода;
  редко меняющееся — раньше.
- **Безопасность:** непривилегированный `USER`, закреплённые версии базового
  образа (digest), без секретов в слоях, `.dockerignore`.
- **Корректность:** `EXPOSE`, `HEALTHCHECK`, явный `ENTRYPOINT`/`CMD`.

## Шаги

1. Прочитай Dockerfile и `.dockerignore` (есть ли он).
2. Пройди по чек-листам выше, отметь находки с severity.
3. Предложи переработанную версию при существенных улучшениях.

## Формат вывода

Список находок (размер / кэш / безопасность) + при необходимости улучшенный
Dockerfile.
