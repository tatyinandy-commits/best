# best — личная коллекция инструментов

Персональный реестр инструментов для Claude Code: скиллы, агенты, slash-команды,
хуки, MCP-конфиги, промпты, bash-утилиты и заметки по best practices.

## Структура

| Папка | Назначение |
|-------|------------|
| [`skills/`](skills/) | Claude Code скиллы (папка с `SKILL.md` внутри) |
| [`agents/`](agents/) | Агенты (`.md` с frontmatter + системный промпт) |
| [`commands/`](commands/) | Slash-команды (`.md` с frontmatter `description`) |
| [`hooks/`](hooks/) | Хуки Claude Code |
| [`mcp/`](mcp/) | Конфигурации MCP-серверов |
| [`prompts/`](prompts/) | Промпты и заметки (свободный markdown) |
| [`scripts/`](scripts/) | Bash-утилиты |
| [`docs/`](docs/) | Заметки по best practices |

## Быстрый старт

Создать новый элемент из шаблона:

```bash
./scripts/new-item.sh <тип> <имя-в-kebab-case>
```

где `<тип>` — один из `skill`, `agent`, `command`, `prompt`. Например:

```bash
./scripts/new-item.sh skill pdf-extractor
./scripts/new-item.sh agent code-reviewer
./scripts/new-item.sh command deploy-staging
./scripts/new-item.sh prompt brainstorming-notes
```

## Реестр

[`catalog.json`](catalog.json) — машиночитаемый реестр всех элементов коллекции.
