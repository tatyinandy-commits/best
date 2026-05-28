---
name: async-patterns
description: >-
  Use when the user has async/concurrent code with bugs — race conditions,
  deadlocks, improper await, leaked promises, or wrong error handling in async
  context. Also for reviewing async code for correctness.
---

# async-patterns

## Назначение

Диагностика и исправление проблем в асинхронном коде.

## Типичные проблемы

### Потерянный Promise (JS/TS)
```js
// ❌ Promise не awaited — ошибка проглочена
doSomethingAsync();

// ✅
await doSomethingAsync();
// или явно обработать
doSomethingAsync().catch(console.error);
```

### Ошибка в async forEach
```js
// ❌ forEach не ждёт async-коллбеки
items.forEach(async (item) => { await process(item); });

// ✅
await Promise.all(items.map(async (item) => { await process(item); }));
// или последовательно:
for (const item of items) { await process(item); }
```

### Python asyncio
```python
# ❌ блокирующий вызов в корутине
async def handler():
    time.sleep(1)  # блокирует event loop!

# ✅
async def handler():
    await asyncio.sleep(1)
```

### Гонки состояний
Используй `asyncio.Lock` (Python) / `Mutex` (Rust) / атомарные операции.

## Шаги диагностики

1. Найди все `async`-функции без `await` на результате.
2. Найди синхронные блокирующие вызовы внутри корутин.
3. Проверь обработку ошибок в параллельных задачах.
