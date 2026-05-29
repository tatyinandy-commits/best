---
name: jwt-auth-review
description: >-
  Use when reviewing a JWT-based auth flow — token validation, refresh rotation,
  2FA/TOTP, session handling, and common JWT pitfalls. Defensive review of your
  own auth. Not for bypassing authentication.
---

# jwt-auth-review

## Назначение

Защитный разбор аутентификации на JWT с refresh-токенами и 2FA.

## Чек-лист JWT

- **Алгоритм фиксирован** на стороне сервера (не доверяй `alg` из заголовка;
  запрет `none`; RS256/ES256 или строго HS256 с секретом достаточной длины).
- **Проверяются** `exp`, `iss`, `aud`, `nbf`.
- **Access-токен короткоживущий** (минуты), refresh — длинный, но ротируется.
- **Нет секретов/PII в payload** (JWT читается клиентом).

## Refresh-токены

- Хранятся в **httpOnly + Secure + SameSite** cookie (не в localStorage).
- **Ротация:** при использовании refresh выдаётся новый, старый инвалидируется.
- **Reuse detection:** повторное использование отозванного refresh → отзыв всей
  сессии/семейства токенов (признак кражи).
- Серверное хранилище позволяет отзыв (logout, смена пароля → инвалидация).

## 2FA (TOTP)

- Секрет TOTP хранится зашифрованным, не в открытом виде.
- Окно проверки узкое (±1 шаг), защита от replay.
- Backup-коды одноразовые, хранятся хэшированными.
- 2FA проверяется до выдачи полноценной сессии.

## Общее

- Bcrypt/argon2 для паролей с адекватным cost-фактором.
- Rate limiting на login/refresh/2FA (защита от brute-force).
- CSRF-защита для cookie-based флоу.

## Формат вывода

Находки по severity с местом и исправлением; отдельно — что проверить
вручную (например, секреты в payload).
