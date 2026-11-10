---
paths:
  - "daw_music_maker_server/**"
---

# Server rules

Follow @docs/conventions/server.md and @docs/conventions/security.md — feature-first,
entities (`serverOnly: true`, UUID v7 ids) / DTOs (`…Request`) / responses (`…Response`) kept
separate, thin endpoints → services → repositories, mappers, `requireLogin`, ownership checks,
server-side DTO validation, typed `AppException`s, no hand-written serialization.

Every endpoint ships with unit + `withServerpod` integration tests: @docs/conventions/testing.md
