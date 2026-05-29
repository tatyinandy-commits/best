---
name: secret-scan
description: >-
  Use when the user wants to find secrets, credentials, or sensitive values
  accidentally committed to source code or present in the working tree —
  API keys, passwords, tokens, private keys. Not for auditing runtime env vars.
---

# secret-scan

## Назначение

Поиск секретов и учётных данных в кодовой базе до того, как они попали в репозиторий.

## Когда использовать

- Проверка перед коммитом/пушем.
- Аудит существующего репозитория на утечки.

## Шаги

1. Если есть `gitleaks` — `gitleaks detect --source . -v`.
2. Если есть `trufflehog` — `trufflehog filesystem . --no-update`.
3. Без инструментов — grep по паттернам:
   ```bash
   grep -rn --include='*.{py,js,ts,yaml,yml,json,env,cfg,conf,sh}' \
     -E '(api_key|secret|password|token|private_key)\s*[:=]\s*["\x27]?[A-Za-z0-9+/]{16,}' .
   ```
4. Проверь `.env*`, `*.pem`, `*.key`, `credentials.*` — не должны быть в git.
5. Проверь историю: `git log --all -p | grep -i 'api_key\|secret\|password'`.

## Формат вывода

Список находок: файл:строка, тип секрета, рекомендация (удалить из истории / ротировать).

## Заметки

Найденные в истории секреты нужно ротировать немедленно — удаление из HEAD недостаточно.
Для очистки истории: `git filter-repo --path <file> --invert-paths`.
