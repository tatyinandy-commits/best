# hooks

Хуки Claude Code — скрипты, которые харнесс запускает на определённых событиях
(`SessionStart`, `PreToolUse`, `PostToolUse`, `Stop` и т.д.). Хуки настраиваются
в `settings.json`, а сами исполняемые файлы удобно хранить здесь.

## Типы событий

- `SessionStart` — при старте сессии (например, прогреть зависимости/линтеры).
- `UserPromptSubmit` — при отправке промпта (можно добавить контекст).
- `PreToolUse` / `PostToolUse` — до/после вызова инструмента.
- `Stop` / `SubagentStop` — когда ассистент/субагент завершает ход.
- `Notification` — когда харнесс шлёт уведомление (ожидание ввода и т.п.).
- `PreCompact` — перед сжатием контекста.

## Готовые хуки в коллекции

| Файл | Событие | Что делает |
|------|---------|------------|
| [`session-start.sh`](session-start.sh) | SessionStart | Проверка здоровья окружения (зависимости, конфликты) |
| [`inject-context.sh`](inject-context.sh) | UserPromptSubmit | Добавляет ветку и статус git в контекст |
| [`block-dangerous-commands.sh`](block-dangerous-commands.sh) | PreToolUse·Bash | Блокирует `rm -rf /`, fork-бомбы, перезапись дисков |
| [`protect-sensitive-files.sh`](protect-sensitive-files.sh) | PreToolUse·Edit | Запрещает правку `.env`, ключей, секретов |
| [`protect-main-branch.sh`](protect-main-branch.sh) | PreToolUse·Bash | Не даёт коммитить/пушить в `main`/`master` |
| [`auto-format.sh`](auto-format.sh) | PostToolUse·Edit | Форматирует изменённый файл (ruff/prettier/gofmt…) |
| [`run-related-tests.sh`](run-related-tests.sh) | PostToolUse·Edit | Запускает тест-файл, связанный с правкой |
| [`pre-commit-lint.sh`](pre-commit-lint.sh) | PreToolUse·Bash | Линт перед `git commit` |
| [`post-tool-logger.sh`](post-tool-logger.sh) | PostToolUse | Логирует вызовы инструментов в JSONL |
| [`notify-on-stop.sh`](notify-on-stop.sh) | Stop | Системное уведомление о завершении |
| [`webhook-notify.sh`](webhook-notify.sh) | Stop·Notification | Отправка уведомления в Slack/Discord webhook |

Подробности по событиям и кодам возврата — в [`../docs/hooks-guide.md`](../docs/hooks-guide.md).

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
