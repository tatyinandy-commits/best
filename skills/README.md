# skills

Claude Code скиллы. Каждый скилл — это **папка** с файлом `SKILL.md` внутри,
который содержит YAML frontmatter (`name`, `description`) и тело с инструкциями.

## Структура

```
skills/
  <skill-name>/
    SKILL.md
    (опционально: вспомогательные файлы, скрипты, ресурсы)
```

## SKILL.md frontmatter

```yaml
---
name: skill-name
description: Когда и зачем использовать этот скилл. Пиши от третьего лица,
  начни с триггера ("Use when ...").
---
```

- `name` — в kebab-case, совпадает с именем папки.
- `description` — главный сигнал для модели: когда подключать скилл. Будь конкретным.

## Создать новый скилл

```bash
./scripts/new-item.sh skill my-skill-name
```

Шаблон лежит в [`_template/`](_template/).
