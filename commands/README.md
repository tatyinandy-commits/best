# commands

Slash-команды для Claude Code. Каждая команда — это `.md` файл с YAML
frontmatter, содержащим как минимум `description`, и телом-промптом, который
выполняется при вызове `/<command-name>`.

## Формат файла

```markdown
---
description: Краткое описание того, что делает команда.
---

Текст промпта команды. Можно использовать $ARGUMENTS для подстановки
аргументов, переданных при вызове.
```

- Имя файла без `.md` становится именем команды: `deploy.md` → `/deploy`.
- `description` показывается в списке доступных команд.

## Создать новую команду

```bash
./scripts/new-item.sh command my-command-name
```

Шаблон: [`_template.md`](_template.md).
