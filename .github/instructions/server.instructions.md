---
applyTo: "daw_music_maker_server/**"
---

Follow [the server conventions](../../docs/conventions/server.md),
[the security conventions](../../docs/conventions/security.md) and
[the testing conventions](../../docs/conventions/testing.md).

- Feature-first: `entities/` (`serverOnly: true`, `id: UuidValue?, defaultPersist=random_v7`),
  `dtos/` (`…Request`), `responses/` (`…Response`), `mappers/`, `repositories/`, `services/`,
  `endpoints/`.
- Thin endpoints with `requireLogin`; caller id only from the session; ownership checks → `notFound`.
- Validate every DTO server-side; throw typed `AppException`s; no hand-written serialization.
- Every endpoint ships with unit + `withServerpod` integration tests.
- Never edit `lib/src/generated/` or `daw_music_maker_client/`.
