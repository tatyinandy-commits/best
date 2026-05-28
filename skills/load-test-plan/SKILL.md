---
name: load-test-plan
description: >-
  Use when the user wants to plan or write a basic load test — defining
  scenarios, thresholds, and running k6/locust/ab. Not for full performance
  engineering or capacity planning at scale.
---

# load-test-plan

## Назначение

Планирование и написание базового нагрузочного теста.

## Шаги

1. Определи сценарии: ключевые пользовательские пути (login, главная страница,
   критичный API).
2. Выбери инструмент:
   - `k6` — JS-скрипты, хорошая интеграция с CI.
   - `locust` — Python, удобно для сложных сценариев.
   - `ab` — быстрая проверка одного эндпоинта.
3. Задай профиль нагрузки: ramp-up, steady state, ramp-down.
4. Определи пороговые значения (SLO): p95 < 200ms, error rate < 1%.
5. Напиши скрипт минимального сценария.

## Пример k6

```js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '1m',  target: 20 },
    { duration: '10s', target: 0 },
  ],
  thresholds: { 'http_req_duration': ['p(95)<200'] },
};

export default function () {
  const res = http.get('https://example.com/api/items');
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(1);
}
```

## Заметки

Запускай в изолированном окружении; не нагружай продакшн без предупреждения.
