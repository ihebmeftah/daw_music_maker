---
paths:
  - "daw_music_maker_flutter/**"
---

# Flutter rules

Follow @docs/conventions/flutter.md — MVVM feature-first, go_router typed routes, Riverpod
(riverpod_generator + build_runner), get_it + injectable bridged into Riverpod, freezed state,
flutter_gen assets, theme tokens only (no hard-coded colors/text styles), shared widgets,
widget classes instead of `_buildX()` methods, no hand-written toJson/fromJson, Form validators
mirroring the server, UUID ids.

Every change ships with unit + widget tests: @docs/conventions/testing.md
