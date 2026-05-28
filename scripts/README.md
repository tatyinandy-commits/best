# scripts

Bash-утилиты для работы с коллекцией.

## new-item.sh

Создаёт новый элемент коллекции из соответствующего шаблона.

```bash
./scripts/new-item.sh <тип> <имя-в-kebab-case>
```

- `<тип>` — один из: `skill`, `agent`, `command`, `prompt`.
- `<имя>` — в kebab-case (строчные буквы, цифры и дефисы).

Поведение по типам:

| Тип | Что создаётся |
|-----|---------------|
| `skill` | `skills/<имя>/SKILL.md` из `skills/_template/SKILL.md` |
| `agent` | `agents/<имя>.md` из `agents/_template.md` |
| `command` | `commands/<имя>.md` из `commands/_template.md` |
| `prompt` | `prompts/<имя>.md` из `prompts/_template.md` |

Скрипт подставляет имя в плейсхолдер `TEMPLATE_NAME` и отказывается
перезаписывать существующие файлы.

## Шаблон новой утилиты

[`_template.sh`](_template.sh).
