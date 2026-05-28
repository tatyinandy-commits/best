---
name: terraform-lint
description: >-
  Use when the user has Terraform code and wants it checked — formatting,
  validation, security issues with tfsec/checkov, and module best practices.
  Not for designing infrastructure architecture.
---

# terraform-lint

## Назначение

Проверка Terraform-кода на форматирование, корректность и безопасность.

## Шаги

1. **Форматирование:** `terraform fmt -recursive -check` (авто-фикс: без `-check`).
2. **Валидация:** `terraform init -backend=false && terraform validate`.
3. **Security scan:**
   - `tfsec .` — ищет небезопасные настройки (открытые S3, HTTP вместо HTTPS).
   - `checkov -d .` — CIS benchmark checks.
4. **Лучшие практики:**
   - Переменные задокументированы (`description`, `type`)?
   - Outputs задокументированы?
   - Нет захардкоженных значений вместо переменных?
   - `required_providers` с версиями?

## Формат вывода

Результаты по этапам: fmt / validate / security / best practices с severity.
