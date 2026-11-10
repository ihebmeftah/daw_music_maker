# Copilot instructions — DAW Music Maker

This repository is a multi-user DAW (music maker) built with a **Flutter** app
(`daw_music_maker_flutter`) and a **Serverpod** backend (`daw_music_maker_server`).
The full project rules are in [AGENTS.md](../AGENTS.md); detailed conventions are in
[docs/conventions/](../docs/conventions/). Path-specific rules are in `.github/instructions/`.

Core rules:

1. Flutter: MVVM feature-first, `go_router` typed routes, Riverpod with `riverpod_generator` +
   `build_runner`, `get_it` + `injectable` for DI, `freezed` state, `flutter_gen` assets.
2. Theme tokens only — no hard-coded colors, text styles or spacing in widgets. Reuse
   `lib/shared/widgets/`; extract widget classes instead of `_buildX()` methods.
3. Server: entities (`serverOnly: true` tables), DTOs (`…Request`) and responses (`…Response`)
   are separate `.spy.yaml` models; endpoints → services → repositories; mappers for entity → response.
4. No hand-written `toJson`/`fromJson`/`toMap` on either side.
5. UUID ids everywhere (`id: UuidValue?, defaultPersist=random_v7`).
6. Validate forms in Flutter and re-validate every DTO on the server.
7. Security: `requireLogin`, caller id from the session only, ownership checks (`notFound` if not
   owned), typed `AppException`s, no secrets in code.
8. Every feature ships with tests: Flutter unit + widget tests; server unit + `withServerpod`
   integration tests.
9. Document everything: `///` dartdoc on public APIs, `###` on `.spy.yaml` fields,
   `docs/features/<feature>.md` per feature.
10. Never edit generated code (`daw_music_maker_client/`, `lib/src/generated/`, `*.g.dart`,
    `*.freezed.dart`). Use the `serverpod` and `dart` MCP servers (`.vscode/mcp.json`).
