---
name: k8s-manifest-check
description: >-
  Use when the user has Kubernetes manifests (Deployment, Service, ConfigMap,
  etc.) and wants them reviewed for correctness, security, and best practices —
  resource limits, liveness probes, RBAC, image pinning. Not for generating
  manifests from scratch.
---

# k8s-manifest-check

## Назначение

Ревью Kubernetes-манифестов на корректность и production-готовность.

## На что смотреть

- **Ресурсы:** `requests` и `limits` заданы для всех контейнеров.
- **Пробы:** `livenessProbe` и `readinessProbe` настроены.
- **Безопасность:** `runAsNonRoot: true`, `readOnlyRootFilesystem: true`,
  `allowPrivilegeEscalation: false`; нет `privileged: true`.
- **Образы:** закреплены digest или точная версия (не `latest`).
- **ConfigMap/Secret:** секреты через `secretKeyRef`, не `configMapKeyRef`.
- **RBAC:** минимальные права; нет `cluster-admin` для приложений.
- **Реплики:** `replicas > 1` для prod; `PodDisruptionBudget` задан?
- **Namespace:** не `default` для prod-сервисов.

## Инструменты

- `kubeval manifest.yaml` — валидация схемы.
- `kube-score score manifest.yaml` — best practices.
- `trivy config manifest.yaml` — security scan.

## Формат вывода

Список находок по секциям (ресурсы / безопасность / надёжность) с severity.
