---
description: Запускает команду под профайлером и суммирует горячие пути.
---

# profile-run

Запусти `$ARGUMENTS` под профайлером и покажи горячие пути.

## Шаги

1. Определи рантайм:
   - Python: `python3 -m cProfile -o profile.out <cmd>`, затем
     `python3 -m pstats profile.out` → `sort cumtime` → `stats 20`.
   - Node.js: `node --cpu-prof <script>` → открыть `.cpuprofile` в Chrome DevTools.
   - Go: добавить `import _ "net/http/pprof"` → `go tool pprof`.
   - bash-скрипт: `time <cmd>` + разбить на части.
2. Запусти профилирование.
3. Выдели топ-10 функций по `cumtime`/`self time`.
4. Укажи явные узкие места.

## Результат

Топ горячих путей + рекомендации по оптимизации для самых тяжёлых.
