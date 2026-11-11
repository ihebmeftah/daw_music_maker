# DAW Music Maker — Flutter & Serverpod project

A multi-user digital audio workstation (in the spirit of a pattern-based DAW): users sign in,
create projects, build patterns in a step sequencer (channel rack) and piano roll, arrange
them on a playlist, mix tracks on a mixer and manage samples. Projects are stored per user on
the server.

- `daw_music_maker_flutter/` — Flutter app (frontend, MVVM)
- `daw_music_maker_server/` — Serverpod server (backend). Always build the backend with Serverpod.
- `daw_music_maker_client/` — generated client. **Never edit.**

Build for multiple users and use Serverpod's built-in authentication, already set up in
`daw_music_maker_server/lib/server.dart`.

## Non-negotiable rules

Detailed rules live in `docs/conventions/`. **Read the relevant file before writing code:**

| Working on…                        | Read                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| Flutter app                        | [docs/conventions/flutter.md](docs/conventions/flutter.md)   |
| Server                             | [docs/conventions/server.md](docs/conventions/server.md)     |
| Any feature (tests are mandatory)  | [docs/conventions/testing.md](docs/conventions/testing.md)   |
| Anything touching data/auth/input  | [docs/conventions/security.md](docs/conventions/security.md) |
| Any public API / model / feature   | [docs/conventions/documentation.md](docs/conventions/documentation.md) |

Summary:

1. **Flutter**: MVVM, feature-first (`features/<f>/data` + `presentation/{views,view_models,state,widgets}`).
   `go_router` (typed routes), Riverpod with `riverpod_generator` + `build_runner`, `get_it` +
   `injectable` for DI (bridged into Riverpod providers), `freezed` state, `flutter_gen` assets.
2. **Theme**: no hard-coded colors/text styles/spacing in widgets — use `core/theme`
   (`colorScheme`, `context.dawColors`, `context.textStyles`, `AppSpacing`). Reuse
   `shared/widgets/` components; extract widget classes instead of `_buildX()` helper methods.
3. **Server**: feature-first; separate **entities** (`serverOnly: true` tables), **DTOs**
   (`…Request`) and **responses** (`…Response`); thin endpoints → services → repositories;
   mappers convert entity → response.
4. **No hand-written serialization/normalization** (`toJson`/`fromJson`/`toMap`) on either
   side — Serverpod and `freezed`/`json_serializable` generate it.
5. **UUIDs everywhere**: `id: UuidValue?, defaultPersist=random_v7` on every table; UUID
   foreign keys and route params.
6. **Validation twice**: Flutter `Form` validators for UX, server re-validates every DTO.
   Validation limits are mirrored in both packages.
7. **Security**: `requireLogin` on feature endpoints, caller id only from the session,
   ownership check on every access by id (`notFound` if not owned), typed `AppException`s,
   no secrets in code.
8. **Tests with every feature**: Flutter unit tests (validators, ViewModels, repositories) +
   widget tests (views, shared widgets); server unit tests + `withServerpod` integration
   tests for each endpoint (unauthenticated, other user, invalid input, happy path).
9. **Docs**: `///` dartdoc on all public APIs, `###` on every `.spy.yaml` class/field,
   and a `docs/features/<feature>.md` per feature.

## Features

Keep this list up to date (one line each, link to `docs/features/<feature>.md`).

- [auth](docs/features/auth.md) — email sign-in, registration and forgot-password flows
  (Serverpod email provider), animated wave UI, dark/light mode; lands on `/projects`
- [projects](docs/features/projects.md) — project CRUD (name, description, genres,
  private/public, contributions), invitations by email, join requests, members with
  read/write roles, discover and inbox
- _planned_: channel rack / step sequencer, piano roll, playlist / arrangement, mixer,
  sample browser, transport

## Serverpod runner & MCP

The server and Flutter app run under the Serverpod runner, a background process per server package. The user attaches to it with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then call `tail_runner_logs` to learn whether it is still starting or why it stopped. If nothing is running, start it with `serverpod runner start` in `daw_music_maker_server`, which returns once the server is up and leaves it running for the user to attach to. If it fails, fix the cause it reports (a build error, a port held by another process, Docker) instead of retrying; only a `serverpod runner start` your shell killed on a timeout is run again, since the runner keeps starting. Flutter apps declared with `auto_launch` launch once the user attaches; launch any app before that with the MCP tool `spawn_flutter_app`. Leave the runner running, and run `serverpod runner stop` only when asked.

While running, the runner watches for file changes to run incremental code generation and hot reload both the server and the Flutter app. `serverpod runner status` prints its state and the server addresses, which are not always the configured ports when another Serverpod runner on the machine holds them.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line for the tasks below. The `serverpod runner` commands are the exception: they manage the stack itself. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_runner_logs` to read the output of the runner itself (code generation, compilation, Docker, raw server output). The only tool that also works while the server is starting or after it stopped.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `daw_music_maker_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead. In the Flutter app, never edit `*.g.dart`, `*.freezed.dart`, `injection.config.dart` or `lib/gen/**` — rerun `build_runner`.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the MCP is not available or `serverpod runner start` cannot bring the server up, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; the runner applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Skills for Serverpod, Flutter and Relic are in `.agents/skills/` (mirrored for Claude in `.claude/skills/` and Cursor in `.cursor/skills/`). Use them for exact API syntax.

## Checklist after doing changes, in this order

- `dart run build_runner build --delete-conflicting-outputs` in `daw_music_maker_flutter` (CLI — if annotations/routes/providers/assets changed)
- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests: `dart test` in the server package and `flutter test` in the Flutter package — new/changed features must have new/updated tests
- Update dartdoc and `docs/features/<feature>.md` (and the Features list above)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

## Testing the running app

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `daw_music_maker_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.
