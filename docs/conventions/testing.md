# Testing conventions

**Every feature ships with tests in the same change.** A feature is not done until its tests
exist and pass. Test files mirror the `lib/` path they cover (`lib/a/b/c.dart` →
`test/a/b/c_test.dart`).

Style for both packages:
- `group('Given …')` / `test('when …, then …')` naming.
- Arrange / Act / Assert, one behavior per test.
- No real network, timers or audio in unit/widget tests — use fakes/mocks (`mocktail`).
- Cover the happy path, validation failures, auth/ownership failures and edge cases
  (empty lists, boundaries such as min/max BPM).

## Flutter (`daw_music_maker_flutter/test/`)

| What                         | Test type     | How                                                                  |
| ---------------------------- | ------------- | -------------------------------------------------------------------- |
| Validators, mappers, utils   | Unit          | plain `test()`                                                       |
| ViewModels                   | Unit          | `ProviderContainer(overrides: [repoProvider.overrideWithValue(mock)])`, assert state transitions (loading → data / error) |
| Repositories                 | Unit          | mock the generated client endpoint (`class MockProjectEndpoint extends Mock implements EndpointProject`) and verify mapping + error → `Failure` |
| Views                        | Widget        | `pumpApp()` helper with `ProviderScope` overrides; verify rendering of loading/data/error and user interaction (tap, enter text, form validation messages) |
| Shared widgets               | Widget        | each widget in `shared/widgets/` has its own widget test              |

- Put shared helpers in `test/helpers/`: `pump_app.dart` (wraps `ProviderScope` +
  `MaterialApp` with `AppTheme` + router), `mocks.dart`, `fakes.dart` (e.g. `FakeAudioEngine`).
- Use `find.byKey(const Key('…'))` for important interactive widgets; define keys as
  constants in the view.
- Run: `flutter test` in `daw_music_maker_flutter`.

## Server (`daw_music_maker_server/test/`)

```
test/
├── unit/          # pure Dart: validators, mappers, services' pure logic — no DB
└── integration/   # withServerpod(...) endpoint tests against the embedded test DB
    └── test_tools/serverpod_test_tools.dart   # generated — don't edit
```

- **Unit**: validation rules, mappers (entity → response), any pure service logic.
- **Integration**: every endpoint method, using `withServerpod` and `sessionBuilder`:

  ```dart
  withServerpod('Given Project endpoint', (sessionBuilder, endpoints) {
    final owner = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(ownerId, {}),
    );
    test('when creating with a blank name, then a validation error is thrown', () async {
      await expectLater(
        endpoints.project.create(owner, CreateProjectRequest(name: ' ', bpm: 140)),
        throwsA(isA<AppException>()),
      );
    });
  });
  ```

- Each endpoint must have tests for: **unauthenticated access is rejected**,
  **another user's resource returns notFound**, **invalid DTO is rejected**, and the happy path.
- Seed data through the ORM inside the test; rely on the default rollback between tests.
- Run: `dart test` in `daw_music_maker_server` (no Docker needed).
