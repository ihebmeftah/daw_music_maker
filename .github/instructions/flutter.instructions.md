---
applyTo: "daw_music_maker_flutter/**"
---

Follow [the Flutter conventions](../../docs/conventions/flutter.md) and
[the testing conventions](../../docs/conventions/testing.md).

- MVVM feature-first: `features/<f>/data` + `presentation/{views,view_models,state,widgets}`.
- go_router typed routes, Riverpod via riverpod_generator, get_it + injectable bridged to Riverpod.
- Theme tokens only (`colorScheme`, `context.dawColors`, `context.textStyles`, `AppSpacing`).
- Reuse `shared/widgets/`; widget classes instead of `_buildX()` helper methods.
- No hand-written toJson/fromJson; UUID ids; Form validators mirroring server rules.
- Every change ships with unit tests (validators, ViewModels, repositories) and widget tests.
