# hooks

Хуки Claude Code — скрипты, которые харнесс запускает на определённых событиях
(`SessionStart`, `PreToolUse`, `PostToolUse`, `Stop` и т.д.). Хуки настраиваются
в `settings.json`, а сами исполняемые файлы удобно хранить здесь.

## Типы событий

- `SessionStart` — при старте сессии (например, прогреть зависимости/линтеры).
- `PreToolUse` / `PostToolUse` — до/после вызова инструмента.
- `Stop` — когда ассистент завершает ход.

## Пример конфигурации в settings.json

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/hooks/session-start.sh" }
        ]
      }
    ]
  }
}
```

## Шаблон

[`_template.sh`](_template.sh) — заготовка хука, читающего JSON-событие из stdin.
Сделай файл исполняемым: `chmod +x hooks/<name>.sh`.
