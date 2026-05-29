---
name: gas-optimize
description: >-
  Use when the user wants to reduce gas costs of Solidity contracts — storage
  packing, caching, calldata, custom errors, loop optimization. Measures gas
  before/after. Not at the expense of security or correctness.
---

# gas-optimize

## Назначение

Снижение расхода газа в смарт-контрактах без потери безопасности.

## Приёмы (по убыванию эффекта)

### Storage
- Упаковка переменных в один слот (uint128+uint128, bool+address).
- `SLOAD` дорог: кэшируй storage-переменную в `memory`/локальную внутри функции.
- `immutable`/`constant` для значений, не меняющихся после деплоя.

### Циклы
- Кэшируй `array.length` перед циклом.
- `++i` вместо `i++`; `unchecked { ++i; }` для счётчика цикла (≥0.8).

### Calldata и типы
- `calldata` вместо `memory` для аргументов-массивов в external-функциях.
- Custom errors (`error InsufficientBalance()`) вместо строк в `require`.

### Прочее
- Избегай лишних `SSTORE` (запись дороже всего).
- Batch-операции вместо множества транзакций.

## Измерение

```bash
forge test --gas-report          # отчёт по газу на функцию
forge snapshot                   # снапшот для сравнения до/после
forge snapshot --diff            # дельта газа
```

## Правила

- Сначала измерь, потом оптимизируй.
- **Не жертвуй проверками безопасности** ради газа (checks-effects-interactions
  важнее экономии SLOAD).
- Перепроверь: оптимизация не изменила поведение (тесты зелёные).

## Формат вывода

Таблица: функция | газ до | газ после | приём | риск.
