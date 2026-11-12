# Patterns — FL Studio–style patterns per project

## 1. Purpose and user stories

A pattern is a named, colored loop of a given length that belongs to a project — the unit
a producer builds and later arranges into a song (FL Studio's pattern concept). It holds
the notes of every channel (step-sequencer steps and piano-roll notes — see
[sequencer.md](sequencer.md)); cloning copies them and shortening drops notes past the
end. Patterns are arranged into a song on the [playlist](playlist.md); deleting a pattern
removes its clips.

- Every project starts with **Pattern 1** (4 bars). Existing projects got one through the
  migration.
- In the studio toolbar I see the current pattern (`◀ [■ Pattern 1 ▾] ▶ +`) and switch with
  the arrows, the menu or the `[` / `]` keys. The timeline loops over the selected
  pattern's length and shows its name.
- As an owner or write member I **add** (+ or menu), **clone**, **rename**, **recolor**
  (8 track colors), **resize** (1, 2, 4, 8 or 16 bars) and **delete** patterns. The last
  pattern cannot be deleted.
- Read members and visitors can switch between patterns but not change them.

## 2. Screens / routes and endpoints

- Studio (`/projects/:id/studio`): `PatternSelector` in `TransportToolbar`, rename via
  `PatternNameDialog`, timeline loop length from the selected pattern. Selection is local
  to each user (not saved).
- Server `client.pattern` (`PatternEndpoint`, `requireLogin`):
  - `list(projectId)` — anyone who can see the project.
  - `create(CreatePatternRequest)` — defaults: "Pattern N" (one above the highest
    "Pattern N"), next palette color, 4 bars, appended at the end.
  - `update(patternId, UpdatePatternRequest)`, `clone(patternId)` (`<name> (copy)`,
    appended), `delete(patternId)` — owner or write member.
- `ProjectService.create` inserts "Pattern 1" in the same transaction as the project.
- Flutter: `StudioRepository` (`listPatterns`, `createPattern`, `updatePattern`,
  `clonePattern`, `deletePattern`), `StudioState.patterns / selectedPatternId /
  selectedPattern / loopBars / isPatternBusy`, `StudioViewModel` (`selectPattern`,
  `stepPattern`, `createPattern`, `cloneSelectedPattern`, `renameSelectedPattern`,
  `setSelectedPatternColor`, `setSelectedPatternLength`, `deleteSelectedPattern`).
- Colors: `DawColors.trackColors` (8 colors, darker set in the light theme),
  `trackColor(colorIndex)`.

## 3. Models

- Entity `Pattern` (`pattern`): `projectId` (cascade with the project), `name`,
  `colorIndex`, `lengthBars`, `position`; unique `(projectId, position)`.
- DTOs `CreatePatternRequest { projectId, name?, colorIndex?, lengthBars? }`,
  `UpdatePatternRequest { name, colorIndex, lengthBars }`.
- Response `PatternResponse`.
- Migration `20261111164238248` creates the table and (hand-written data step) inserts
  "Pattern 1" for every existing project; the resulting schema matches `definition.sql`.

## 4. Validation rules and security notes

| Rule                 | Server                          | Flutter                         |
| -------------------- | ------------------------------- | ------------------------------- |
| Name                 | 1–40 chars after trimming       | `Validators.patternName`        |
| Color index          | 0–7                             | palette of 8                    |
| Length               | 1–16 bars                       | menu offers 1, 2, 4, 8, 16      |
| Patterns per project | ≤ 99 (`limitReached`)           | Clone disabled at the cap       |

- Not visible project/pattern → `notFound`; read member or visitor changing → `forbidden`;
  deleting the last pattern → `conflict` (checked in a transaction).

## 5. How it is tested

- Server: `unit/features/patterns/services/pattern_rules_test.dart`;
  `integration/pattern_endpoint_test.dart` (every method: unauthenticated, other user's
  project, read member, public visitor listing, invalid input, happy path; default
  "Pattern 1", defaults for new patterns, clone naming, last-pattern conflict, cascade,
  order, cap of 99).
- Flutter: repository delegation (`studio_repository_impl_test`), ViewModel pattern
  actions (`studio_patterns_test`: select/step wrap, create, clone, rename/recolor/resize,
  delete selects the neighbor, failures, read-only, load failure), `pattern_selector_test`
  (arrows, +, menu select/clone/rename/delete, length and color submenus, single-pattern
  and read-only states) and `studio_view_test` (`[` / `]` switching updates the timeline,
  rename dialog, + selects the new pattern, read member has no +).
