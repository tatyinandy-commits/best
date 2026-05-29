# Установка коллекции в проект (Forgejo / любой git)

Эта коллекция — набор инструментов для **твоего** Claude Code, который ты
запускаешь там, где лежит код проекта. Доступ из облака к твоему серверу не нужен:
ты подключаешь коллекцию локально в проект, и скиллы работают с реальным кодом.

## Как Claude Code находит инструменты

| Тип | Уровень проекта | Уровень пользователя |
|-----|-----------------|----------------------|
| Skills | `<project>/.claude/skills/<name>/SKILL.md` | `~/.claude/skills/...` |
| Agents | `<project>/.claude/agents/<name>.md` | `~/.claude/agents/...` |
| Commands | `<project>/.claude/commands/<name>.md` | `~/.claude/commands/...` |
| Hooks/settings | `<project>/.claude/settings.json` | `~/.claude/settings.json` |
| MCP | `<project>/.mcp.json` | пользовательский конфиг |

## Вариант 1. Git submodule (рекомендуется)

Держит коллекцию версионированной и обновляемой. Зеркаль репозиторий коллекции
на свой Forgejo (или используй как есть), затем в проекте:

```bash
cd <project>
git submodule add <forgejo-url>/best .claude-tools
# Разложить элементы в .claude/ симлинками на submodule:
./.claude-tools/scripts/install.sh .
git add .gitmodules .claude
git commit -m "chore: add Claude Code tools collection"
```

Обновление позже:

```bash
git submodule update --remote .claude-tools
./.claude-tools/scripts/install.sh .   # пересоздаст симлинки
```

## Вариант 2. Скрипт install.sh

Если коллекция склонирована рядом:

```bash
git clone <forgejo-url>/best ~/tools/best
~/tools/best/scripts/install.sh /path/to/project       # симлинки
~/tools/best/scripts/install.sh /path/to/project --copy # копии (без симлинков)
~/tools/best/scripts/install.sh --user                  # в ~/.claude (глобально)
```

Скрипт раскладывает skills/agents/commands в `.claude/` и печатает готовые
сниппеты для hooks и MCP.

## Вариант 3. Вручную

```bash
mkdir -p <project>/.claude
ln -s ~/tools/best/skills   <project>/.claude/skills
ln -s ~/tools/best/agents   <project>/.claude/agents
ln -s ~/tools/best/commands <project>/.claude/commands
```

## Hooks — подключай осознанно

Hooks выполняются автоматически, поэтому включай только нужные. В
`<project>/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [
        { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude-tools/hooks/block-dangerous-commands.sh" },
        { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude-tools/hooks/protect-main-branch.sh" }
      ]},
      { "matcher": "Edit|Write|MultiEdit", "hooks": [
        { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude-tools/hooks/protect-sensitive-files.sh" }
      ]}
    ],
    "PostToolUse": [
      { "matcher": "Edit|Write|MultiEdit", "hooks": [
        { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude-tools/hooks/auto-format.sh" }
      ]}
    ]
  }
}
```

Сделай скрипты исполняемыми: `chmod +x .claude-tools/hooks/*.sh`.

## MCP — скопируй и подставь секреты

В `<project>/.mcp.json` добавь нужные серверы из `mcp/` коллекции. Секреты — через
переменные окружения, не хардкодь:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "POSTGRES_CONNECTION_STRING": "${POSTGRES_CONNECTION_STRING}" }
    }
  }
}
```

Для прод-БД используй **read-only** креды.

## Forgejo Actions — держи каталог в синхроне

Если коллекция живёт в Forgejo, добавь workflow, проверяющий актуальность
`catalog.json` (`.forgejo/workflows/catalog.yml`):

```yaml
on: [push, pull_request]
jobs:
  catalog-check:
    runs-on: docker
    steps:
      - uses: actions/checkout@v4
      - run: python3 scripts/build-catalog.py --check
```

## Проверка установки

```bash
ls -la <project>/.claude/skills      # симлинки/папки скиллов на месте
```

Запусти Claude Code в проекте и проверь, что нужные скиллы/команды доступны.
