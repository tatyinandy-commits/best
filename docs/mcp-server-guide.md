# Настройка MCP-серверов

Практические советы по конфигурации и использованию MCP (Model Context Protocol)
в Claude Code.

## Как работает MCP

Claude Code запускает MCP-серверы как дочерние процессы (stdio) или подключается
к HTTP/SSE-эндпоинтам. Инструменты сервера становятся доступны в текущей сессии.

## Где хранить конфиги

- `~/.claude/settings.json` — пользовательские (глобальные).
- `.claude/settings.json` в репозитории — проектные.
- Конфиги в `mcp/` этой коллекции — заготовки для копирования.

## Пример подключения (settings.json)

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

## Работа с секретами

Никогда не коммить токены в конфиги. Используй переменные окружения:
```json
{ "env": { "API_KEY": "${MY_API_KEY}" } }
```
Задавай их в `.env` или через `export` в профиле шелла.

## Отладка

- Логи сервера: проверь stderr процесса.
- Инструменты не появились: убедись, что пакет установлен и путь верный.
- Разрешения: в `settings.json` → `permissions` можно разрешить конкретные tool calls.

## Конфиги в коллекции

| Файл | Сервер | Назначение |
|------|--------|-----------|
| `filesystem.json` | @mcp/filesystem | Доступ к локальным файлам |
| `github.json` | @mcp/github | GitHub API через MCP |
| `postgres.json` | @mcp/postgres | SQL-запросы к PostgreSQL |
| `brave-search.json` | @mcp/brave-search | Веб-поиск через Brave |
