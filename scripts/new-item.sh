#!/usr/bin/env bash
# new-item.sh — создаёт новый элемент коллекции из шаблона.
#
# Использование:
#   ./scripts/new-item.sh <тип> <имя-в-kebab-case>
#
# Типы:
#   skill   -> skills/<имя>/SKILL.md      (из skills/_template/SKILL.md)
#   agent   -> agents/<имя>.md            (из agents/_template.md)
#   command -> commands/<имя>.md          (из commands/_template.md)
#   prompt  -> prompts/<имя>.md           (из prompts/_template.md)
#
# Плейсхолдер TEMPLATE_NAME в шаблоне заменяется на <имя>.
set -euo pipefail

# Корень репозитория = родитель папки scripts.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat >&2 <<'EOF'
Использование: new-item.sh <тип> <имя-в-kebab-case>

  <тип>  один из: skill, agent, command, prompt
  <имя>  строчные буквы, цифры и дефисы (kebab-case)

Примеры:
  new-item.sh skill   pdf-extractor
  new-item.sh agent   code-reviewer
  new-item.sh command deploy-staging
  new-item.sh prompt  brainstorming-notes
EOF
  exit 2
}

die() { echo "Ошибка: $*" >&2; exit 1; }

# --- аргументы ---
[ "$#" -eq 2 ] || usage
type="$1"
name="$2"

# --- валидация имени (kebab-case) ---
if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  die "имя '$name' должно быть в kebab-case (например: my-tool-name)"
fi

# --- определить пути по типу ---
case "$type" in
  skill)
    template="$ROOT_DIR/skills/_template/SKILL.md"
    target="$ROOT_DIR/skills/$name/SKILL.md"
    ;;
  agent)
    template="$ROOT_DIR/agents/_template.md"
    target="$ROOT_DIR/agents/$name.md"
    ;;
  command)
    template="$ROOT_DIR/commands/_template.md"
    target="$ROOT_DIR/commands/$name.md"
    ;;
  prompt)
    template="$ROOT_DIR/prompts/_template.md"
    target="$ROOT_DIR/prompts/$name.md"
    ;;
  *)
    echo "Неизвестный тип: '$type'" >&2
    usage
    ;;
esac

[ -f "$template" ] || die "шаблон не найден: $template"
[ -e "$target" ]  && die "файл уже существует: $target"

# --- создать из шаблона с подстановкой имени ---
mkdir -p "$(dirname "$target")"
sed "s/TEMPLATE_NAME/$name/g" "$template" > "$target"

echo "Создан $type: ${target#"$ROOT_DIR"/}"
echo "Не забудь обновить catalog.json"
