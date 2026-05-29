---
name: dead-code-hunter
description: >-
  Use when the user wants a deeper dead code analysis than linting — tracing
  unreachable branches, deprecated feature flags, tombstoned experiments, or
  code paths that can never execute. Goes beyond unused variable warnings.
---

# dead-code-hunter

## Назначение

Углублённый поиск мёртвого кода: недостижимые ветки, устаревшие флаги,
завершённые эксперименты.

## На что смотреть

- **Недостижимые ветки:** `if (false)`, `if (ENV === 'legacy')` и ENV никогда не
  бывает 'legacy', `if (featureFlag.REMOVED)`.
- **Устаревшие feature flags:** флаги, которые раскатаны на 100% и можно удалить.
- **Tombstoned пути:** обработчики событий / эндпоинты, которые никто не вызывает.
- **Мёртвые интерфейсы:** методы публичного API без единого вызова снаружи.

## Шаги

1. Пройди по существующим варнингам линтера (`no-unused-vars`, `W0611`).
2. Поищи константы `= false` / `= 0` / `= null` в условиях.
3. Найди имена завершённых экспериментов в строках и проверь, используются ли.
4. Проверь, не задан ли feature-flag жёстко в конфиге.
5. Для каждой находки оцени: безопасно удалить, или нужна проверка?

## Формат вывода

Находки с типом (feature-flag / недостижимая ветка / мёртвый интерфейс),
уверенность и рекомендация.
