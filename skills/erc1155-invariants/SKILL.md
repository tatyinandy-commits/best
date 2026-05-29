---
name: erc1155-invariants
description: >-
  Use when reviewing or testing an ERC-1155 token contract (e.g. tokenized
  property shares) — checking supply/balance invariants, transfer safety,
  approval logic, and metadata correctness. Not for designing tokenomics.
---

# erc1155-invariants

## Назначение

Проверка инвариантов ERC-1155 — токенов, представляющих доли (например, доли
в недвижимости).

## Ключевые инварианты

1. **Сумма балансов = total supply** для каждого `id`:
   `Σ balanceOf(holder, id) == totalSupply(id)` всегда.
2. **Mint/burn меняют supply согласованно** — нет mint без увеличения supply.
3. **Переводы сохраняют сумму:** `from` уменьшается ровно на столько, на сколько
   растёт `to`; нельзя перевести больше баланса.
4. **safeTransferFrom** вызывает `onERC1155Received` у контракта-получателя и
   проверяет возвращаемый magic value.
5. **batch-операции** атомарны: либо все, либо ни одной (массивы `ids`/`amounts`
   одной длины).
6. **Approval:** `setApprovalForAll` корректно ограничивает операторов;
   нельзя переводить без approval/владения.

## Тесты (Foundry invariant testing)

```solidity
// invariant: суммарный баланс равен supply
function invariant_supplyMatchesBalances() public {
    assertEq(sumBalances(TOKEN_ID), token.totalSupply(TOKEN_ID));
}
```

## На что смотреть в доменном контексте долей

- Дивиденды считаются от баланса на snapshot — нет ли double-claim?
- Перевод доли переносит право на будущие дивиденды корректно?
- Округление при распределении: куда идёт остаток (dust)?

## Формат вывода

Список нарушенных/непроверенных инвариантов + предложенные invariant/fuzz-тесты.
