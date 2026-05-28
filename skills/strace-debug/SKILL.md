---
name: strace-debug
description: >-
  Use when a process behaves unexpectedly at the OS level — wrong file paths,
  missing permissions, unexpected network calls, hanging syscalls. Uses strace
  (Linux) or dtruss (macOS) to trace system calls.
---

# strace-debug

## Назначение

Отладка на уровне системных вызовов: что делает процесс когда API/логов недостаточно.

## Когда использовать

- Процесс пытается открыть не тот файл / нет прав / неверный путь.
- Непонятные зависания — в каком syscall застрял?
- Неожиданные сетевые вызовы — что программа лезет в сеть?

## Инструменты

**Linux (strace)**
```bash
# Трассировать новый процесс
strace -f -e trace=file,network <cmd>

# Подключиться к живому процессу
strace -f -p <pid>

# Только open/read/write + timing
strace -T -e trace=read,write,open,openat <cmd>

# Сохранить в файл
strace -f -o /tmp/trace.out <cmd>
```

**macOS (dtruss)**
```bash
sudo dtruss -f <cmd>
```

## Анализ вывода

- `ENOENT` — файл не найден, смотри путь.
- `EACCES` / `EPERM` — нет прав.
- `EAGAIN` / `EWOULDBLOCK` — неблокирующий вызов, нет данных.
- Зависание: найди незавершённый syscall перед сигналом/концом.

## Заметки

В контейнере может потребоваться `--cap-add=SYS_PTRACE`.
