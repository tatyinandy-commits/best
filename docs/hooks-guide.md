# Хуки Claude Code

Практическое руководство по написанию хуков для Claude Code (claude-code hooks).

## Типы событий

| Событие | Когда срабатывает | stdin |
|---------|-------------------|-------|
| `SessionStart` | Старт сессии | `{}` |
| `UserPromptSubmit` | Отправка промпта пользователем | `{prompt}` |
| `PreToolUse` | Перед вызовом инструмента | `{tool_name, tool_input}` |
| `PostToolUse` | После вызова инструмента | `{tool_name, tool_input, tool_response}` |
| `Stop` | Когда ассистент завершает ход | `{}` |
| `SubagentStop` | Когда субагент завершает ход | `{}` |
| `Notification` | Уведомление харнесса (ожидание ввода и т.п.) | `{message}` |
| `PreCompact` | Перед сжатием контекста | `{}` |

## Коды возврата

- `exit 0` — успех. stdout передаётся в контекст модели.
- `exit 2` — блокировать вызов инструмента (только PreToolUse); stderr → модели.
- Любой другой — ошибка хука (не блокирует).

## Конфигурация в settings.json

```json
{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "./hooks/session-start.sh"}]}],
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": "./hooks/pre-commit-lint.sh"}]
    }]
  }
}
```

`matcher` — имя инструмента (точное) или `*` для всех.

## Советы

- Хуки должны быть быстрыми — особенно PreToolUse, он запускается на каждый вызов.
- Делай хуки идемпотентными.
- В сложных хуках используй `python3` вместо `bash` для удобного парсинга JSON.
- Логируй в файл, а не в stdout — stdout идёт в контекст модели.
- Тестируй хук отдельно: `echo '{"tool_name":"Bash","tool_input":{"command":"git commit"}}' | ./hooks/pre-commit-lint.sh`.
