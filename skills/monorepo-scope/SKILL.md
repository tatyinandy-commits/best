---
name: monorepo-scope
description: >-
  Use when the user works in a monorepo and wants to identify which packages
  are affected by a change, run scoped commands, or understand the dependency
  graph between packages. Not for setting up a monorepo from scratch.
---

# monorepo-scope

## Назначение

Работа с монорепозиторием: определение затронутых пакетов и скоупинг команд.

## Определение изменённых пакетов

### Nx
```bash
npx nx affected:apps --base=main
npx nx affected:test --base=main
```

### Turborepo
```bash
npx turbo run test --filter=...[main]
```

### pnpm workspaces (вручную)
```bash
# Файлы изменённые с main
changed=$(git diff --name-only main...HEAD)
# Найти пакеты, которых касаются изменения
for pkg in packages/*/; do
  if echo "$changed" | grep -q "^${pkg}"; then echo "$pkg"; fi
done
```

### Lerna (legacy)
```bash
npx lerna changed
npx lerna run test --since=main
```

## Шаги

1. Определи инструмент монорепо по `package.json` / `nx.json` / `turbo.json`.
2. Найди изменённые пакеты относительно основной ветки.
3. Определи транзитивные зависимости: что ломается если изменился пакет A.
4. Запусти команду только для затронутых пакетов.
