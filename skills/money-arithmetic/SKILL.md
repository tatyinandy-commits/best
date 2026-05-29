---
name: money-arithmetic
description: >-
  Use when code handles money, prices, shares, or token amounts and the user
  wants it checked for correctness — no floats, correct rounding, consistent
  units/decimals. Critical for fintech and tokenized assets.
---

# money-arithmetic

## Назначение

Проверка денежных вычислений на корректность — критично для финтеха и токенов.

## Железные правила

1. **Никаких float/double для денег.** Используй:
   - целые в минимальных единицах (центы, wei) + явный масштаб;
   - decimal-типы (Python `Decimal`, JS `decimal.js`/BigInt, PostgreSQL `NUMERIC`).
2. **Единицы явные.** Не смешивай евро и центы, токены и wei. Один тип = одна
   единица; конвертация — в одном месте.
3. **Округление осознанное.** Задай режим (banker's / half-up) и где он
   применяется. Деньги нельзя «терять» при округлении.
4. **Умножай до деления.** `(amount * rate) / total`, а не `amount * (rate/total)`.
5. **Распределение без потери суммы.** При делении на доли сумма частей == целому;
   остаток (dust) направляй детерминированно (например, последнему/первому).

## Антипаттерны

```python
# ❌ float
price = 0.1 + 0.2   # 0.30000000000000004
# ✅ Decimal
from decimal import Decimal
price = Decimal("0.1") + Decimal("0.2")  # 0.3
```

```sql
-- ❌ FLOAT/REAL для сумм
balance REAL
-- ✅
balance NUMERIC(38, 18)   -- хватает для wei-точности
```

## На что смотреть

- Типы колонок БД для денег (`NUMERIC`, не `float`).
- Сериализация через JSON (float теряет точность — передавай строкой).
- Деление дивидендов на доли — сумма выплат == объявленному дивиденду?

## Формат вывода

Находки: место | проблема (float/единицы/округление) | исправление.
