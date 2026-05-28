---
name: changelog-from-commits
description: >-
  Use when the user wants a CHANGELOG or release notes generated from git
  history — summarizing commits since the last tag, grouping by type, and
  formatting for a release. Not for writing arbitrary prose docs.
---

# changelog-from-commits

## Назначение

Сборка человекочитаемого changelog/release notes из истории git.

## Когда использовать

- Нужны release notes к новой версии.
- Нужно обновить `CHANGELOG.md` по коммитам с последнего тега.

## Шаги

1. Найди последний тег: `git describe --tags --abbrev=0` (если нет — с начала).
2. Собери коммиты: `git log <tag>..HEAD --pretty=format:'%s (%h)'`.
3. Сгруппируй по Conventional Commits (`feat`, `fix`, `docs`, `refactor`,
   `perf`, `chore`); прочее — в «Other».
4. Отбрось шум (`Merge`, пустые). Перефразируй в пользовательские формулировки.
5. Сформируй секцию в формате [Keep a Changelog](https://keepachangelog.com):
   заголовок версии + дата, подзаголовки Added/Fixed/Changed.

## Формат вывода

```markdown
## [X.Y.Z] - YYYY-MM-DD
### Added
- ...
### Fixed
- ...
```

## Заметки

- Уважай существующий стиль `CHANGELOG.md`, если он есть.
- Не выдумывай изменений, которых нет в истории.
