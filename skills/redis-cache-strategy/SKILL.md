---
name: redis-cache-strategy
description: >-
  Use when designing or reviewing Redis usage — caching patterns, TTLs,
  invalidation, rate limiting, locks, and avoiding stale data or stampedes.
  Not for Redis cluster ops/provisioning.
---

# redis-cache-strategy

## Назначение

Проектирование и ревью использования Redis: кэш, rate limiting, локи.

## Паттерны кэширования

- **Cache-aside (lazy):** читаем из кэша → промах → из БД → кладём в кэш с TTL.
  Самый частый; следи за инвалидацией.
- **Write-through:** пишем в кэш и БД синхронно — консистентно, но медленнее.
- **TTL обязателен** — нет вечных ключей (кроме явных справочников).

## Типичные проблемы

### Cache stampede (thundering herd)
Много запросов одновременно промахиваются и бьют в БД при истечении TTL.
- Решение: distributed lock на пересчёт (`SET key val NX EX`), или
  вероятностное раннее обновление (early expiration), или stale-while-revalidate.

### Stale data
- Инвалидация при записи в БД (удали/обнови ключ).
- Не кэшируй то, что должно быть строго актуальным (балансы — осторожно!).

### Rate limiting
- Sliding window / token bucket через `INCR` + `EXPIRE` (атомарно, в Lua-скрипте
  или `INCR` с проверкой).

### Distributed locks
- `SET key token NX PX <ttl>` для лока; снятие — только владельцем (сравни token
  в Lua, иначе снимешь чужой лок). Для критичного — Redlock с оговорками.

## На что смотреть в финтех-контексте

- **Балансы/деньги не кэшируй без крайней нужды** — риск показать устаревшее.
- Сессии и 2FA-стейт: корректный TTL, инвалидация при logout.

## Формат вывода

Находки: ключ/паттерн | проблема (stale/stampede/no-TTL/lock) | рекомендация.
