# mcp

Конфигурации MCP-серверов (Model Context Protocol). Здесь хранятся
переиспользуемые описания серверов, которые можно подключать в проекты через
`.mcp.json` или пользовательский конфиг Claude Code.

## Формат

Каждый сервер описывается записью в объекте `mcpServers`:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@scope/mcp-server"],
      "env": { "API_KEY": "${API_KEY}" }
    }
  }
}
```

Для серверов поверх HTTP/SSE:

```json
{
  "mcpServers": {
    "remote-server": {
      "type": "http",
      "url": "https://example.com/mcp",
      "headers": { "Authorization": "Bearer ${TOKEN}" }
    }
  }
}
```

## Правила

- Не коммить секреты — используй `${ENV_VAR}` подстановку.
- Один файл на сервер удобно называть `<server-name>.json`.

## Шаблон

[`_template.json`](_template.json).
