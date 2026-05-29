---
name: rate-limit-debug
description: >-
  Use when an API is returning 429 errors or the user suspects rate limiting —
  identifying which limit was hit, calculating safe request rates, and
  implementing backoff. Not for bypassing legitimate rate limits.
---

# rate-limit-debug

## Назначение

Диагностика и устранение проблем с rate limiting внешних API.

## Шаги

1. Определи тип лимита по заголовкам ответа:
   - `Retry-After` — жди указанное количество секунд.
   - `X-RateLimit-Remaining`, `X-RateLimit-Reset` — сколько осталось и когда сброс.
   - `X-Rate-Limit-*` — зависит от провайдера.
2. Вычисли безопасную скорость: `N requests / window_seconds` с запасом 20%.
3. Реализуй backoff-стратегию:
   ```python
   import time, random
   def with_retry(fn, max_retries=5):
       for attempt in range(max_retries):
           try: return fn()
           except RateLimitError:
               wait = (2 ** attempt) + random.uniform(0, 1)  # exp backoff + jitter
               time.sleep(wait)
       raise Exception("Max retries exceeded")
   ```
4. Для батчинга — добавь `asyncio.Semaphore(N)` или `throttle(N per second)`.

## Заметки

Никогда не обходи rate limits агрессивно — это нарушение ToS и риск бана.
