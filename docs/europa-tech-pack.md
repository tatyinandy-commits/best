# Europa-tech pack — инструменты под платформу дробных инвестиций

Тематический набор для проекта вроде Europa-tech.org (токенизированные доли в
недвижимости: ERC-1155 на Base, PostgreSQL, Redis, JWT/2FA, AI-аналитика).
Контент оригинальный, по мотивам распространённых отраслевых практик.

> ⚠️ Важно: эти элементы написаны «по мотивам стека» без доступа к реальному
> коду Europa-tech. Используй их как качественные стартовые шаблоны и подгони
> под фактическую кодовую базу. Темы безопасности/комплаенса — техническая
> помощь, не юридическая консультация.

## Web3 / смарт-контракты

| Элемент | Тип | Назначение |
|---------|-----|-----------|
| `solidity-audit` | skill | Аудит Solidity: реентрантность, access control, арифметика |
| `erc1155-invariants` | skill | Инварианты ERC-1155 для токенизированных долей |
| `gas-optimize` | skill | Снижение газа без потери безопасности |
| `onchain-event-index` | skill | Индексация событий, реорги, сверка on/off-chain |
| `smart-contract-auditor` | agent | Защитный аудит контрактов |
| `base-rpc` | mcp | RPC-доступ к Base для чтения on-chain данных |

## Финансы / корректность

| Элемент | Тип | Назначение |
|---------|-----|-----------|
| `money-arithmetic` | skill | Денежные вычисления без float, корректное округление |
| `dividend-reconcile` | skill | Корректность распределения дивидендов по долям |
| `idempotency-check` | skill | Идемпотентность платежей/переводов |

## Безопасность / комплаенс

| Элемент | Тип | Назначение |
|---------|-----|-----------|
| `jwt-auth-review` | skill | Ревью JWT/refresh-ротации/2FA |
| `gdpr-pii-audit` | skill | Аудит обращения с PII под GDPR |
| `redis-cache-strategy` | skill | Паттерны Redis: кэш, rate limit, локи |
| `fintech-compliance-reviewer` | agent | KYC/AML, audit trail, EU-регламенты |

## Как применять

1. Начни с аудита перед деплоем: `smart-contract-auditor` + `solidity-audit` +
   `erc1155-invariants`.
2. Проверь финкорректность: `money-arithmetic`, `dividend-reconcile`,
   `idempotency-check`.
3. Прогони безопасность/комплаенс: `jwt-auth-review`, `gdpr-pii-audit`,
   `fintech-compliance-reviewer`.
4. Для надёжности данных: `onchain-event-index`, `redis-cache-strategy`.

## Что ещё стоит добавить под реальный код

- `CLAUDE.md` в самом репозитории Europa-tech с архитектурой и конвенциями.
- Скиллы под конкретные сервисы/модули после знакомства с кодовой базой.
- MCP-конфиг под ваш индексатор/ноду и (с осторожностью) под прод-БД (read-only).
