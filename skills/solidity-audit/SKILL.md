---
name: solidity-audit
description: >-
  Use when reviewing Solidity smart contracts for security vulnerabilities —
  reentrancy, access control, integer issues, unchecked calls, oracle/price
  manipulation. Defensive review of your own contracts. Not for writing exploits.
---

# solidity-audit

## Назначение

Защитный аудит смарт-контрактов на Solidity: поиск уязвимостей до деплоя.

## Чек-лист уязвимостей

### Реентрантность
- Внешние вызовы (`call`, `transfer`, ERC-1155 `safeTransferFrom` с хуком
  `onERC1155Received`) — после изменения состояния (**checks-effects-interactions**).
- `nonReentrant` (OpenZeppelin `ReentrancyGuard`) на функциях с внешними вызовами.

### Access control
- Критичные функции (mint, pause, withdraw, upgrade) защищены `onlyOwner`/ролями?
- Нет ли `tx.origin` для авторизации (используй `msg.sender`)?
- Двухшаговая передача владения (`Ownable2Step`)?

### Арифметика и переводы
- Solidity ≥0.8 — overflow проверяется, но проверь `unchecked`-блоки.
- Возвраты `call` проверяются (`(bool ok, ) = ...; require(ok)`)?
- Нет ли потери точности при делении до умножения?

### Прочее
- Oracle/цена: устойчивость к манипуляции (TWAP, а не spot)?
- `delegatecall` в proxy: storage layout совместим?
- События эмитятся при изменении состояния?
- DoS: неограниченные циклы по массивам, growth-атаки?

## Инструменты

```bash
slither .                    # статический анализ
myth analyze contract.sol    # symbolic execution (mythril)
forge test                   # тесты, включая fuzzing
```

## Формат вывода

Находки по severity (critical/high/medium/low) с `файл:строка`, описанием
вектора и конкретным исправлением. Без рабочих эксплойтов.
