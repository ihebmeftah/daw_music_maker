# Sequencer — channel rack, piano roll and drum samples

## 1. Purpose and user stories

FL Studio–style beat making inside the studio (`/projects/:id/studio`):

- Every project has a **channel rack** that starts with four drum channels — **Kick,
  Snare, Hat (closed) and Open Hat** — each playing a bundled sample. Existing projects
  got them through the migration.
- In the **Channel rack** view I click steps (16 per bar, shaded per beat) to program a
  drum pattern; lit steps use the channel's track color and the playhead column is
  outlined while playing. Each row has a mute LED, a volume slider and a menu (open in
  piano roll, delete). **+ CHANNEL** adds a channel playing any of the four samples.
- In the **Piano roll** view I pick a channel and click a pitch × step grid to add a
  one-step note (click a note to remove it). The keyboard previews pitches; C5 (60, FL
  naming) plays the sample unpitched, other pitches transpose it.
- Channels can also play **uploaded samples**, with sampler settings (trim, pan, pitch)
  — see [samples.md](samples.md). Double-clicking a channel opens its sampler; the piano
  roll is in the channel menu.
- Pressing **play** loops the selected pattern at the project tempo: every unmuted
  channel plays its notes; the metronome (speaker toggle / M) clicks on top.
- Notes are saved per pattern automatically 600 ms after the last edit.
- Read members and visitors can listen, preview and switch views but not edit.

## 2. Screens / routes and endpoints

Studio workspace (below the timeline): `DawSegmentedControl` **Channel rack | Piano
roll** → `ChannelRack` / `PianoRoll` widgets. Double-clicking a channel name opens it in
the piano roll.

Server:
- `client.channel` (`ChannelEndpoint`): `list(projectId)` (visible project), `create`,
  `update` (name, volume, mute), `delete` (owner / write member; deleting removes the
  channel's notes in every pattern).
- `client.pattern.listNotes(patternId)` / `saveNotes(patternId, SavePatternNotesRequest)` —
  save replaces the pattern's whole note list in a transaction.
- New projects get the default rack and "Pattern 1" in the project's creation transaction.
- Cloning a pattern copies its notes; shortening a pattern deletes notes that no longer fit
  (the client mirrors this locally).

Flutter:
- `core/audio/metronome.dart` is the transport: it advances in 1/16 **steps**
  (`stepIntervalFor(bpm)`), exposes `step` (playhead) and `onStep` (sequencer), and clicks
  on beats only. `beatPosition` stays in beats for the timeline.
- `core/audio/audio_engine(_impl).dart`: `playSample(sample, volume, rate)` with 4
  preloaded players per sample used round-robin (overlapping hits); pitch is applied as
  playback rate `2^((pitch − 60) / 12)`. `audioEngineProvider` exposes it to Riverpod.
- `features/studio/data/studio_note.dart` (`StudioNote`, freezed) and `StudioRepository`
  channel / note methods.
- `StudioViewModel`: `toggleStep`, `togglePianoNote`, `preview`, `openPianoRoll`,
  `selectChannel`, `setWorkspace`, `toggleChannelMute` (optimistic, reverted on failure),
  `setChannelVolume` / `commitChannelVolume`, `addChannel`, `deleteChannel`, `saveNotes`
  (debounced by `noteSaveDelay`), and `_playStep` driven by the transport.
- Assets (`assets/audio/samples/`): `kick.wav`, `snare.wav`, `closed_hat.wav`,
  `open_hat.wav` — synthesized (no third-party samples), 16-bit mono 44.1 kHz.

## 3. Models

- Enum `SampleKind { kick, snare, closedHat, openHat }`.
- Entity `Channel` (`channel`): `projectId` (cascade), `name`, `sample`, `volume`,
  `muted`, `position`; unique `(projectId, position)`. Response `ChannelResponse`; DTOs
  `CreateChannelRequest { projectId, sample, name? }`, `UpdateChannelRequest { name,
  volume, muted }`.
- Entity `PatternNote` (`pattern_note`): `patternId` (cascade), `channelId` (cascade),
  `tick`, `lengthTicks`, `pitch`, `velocity`. DTOs `NoteInput`, `SavePatternNotesRequest`;
  response `NoteResponse`.
- Migration `20261111165902517` creates both tables and (hand-written data step) inserts the
  default rack for every existing project; the schema matches `definition.sql`.

## 4. Validation rules and security notes

| Rule                  | Value                                                    |
| --------------------- | -------------------------------------------------------- |
| Time unit             | ticks, 960 per quarter note; a step is 240 ticks         |
| Note start / length   | `0 ≤ tick < pattern length`, `lengthTicks ≥ 1`, ends inside |
| Pitch / velocity      | 0–127 / 1–127                                            |
| Notes per pattern     | ≤ 4096 (`limitReached`)                                  |
| Channel name / volume | 1–40 chars / 0.0–1.0                                     |
| Channels per project  | ≤ 32 (`limitReached`)                                    |

- Notes must reference channels of the pattern's own project (a channel id from another
  project is a `validation` error, so ids can't be used across projects).
- Visibility and edit rules match patterns: not visible → `notFound`; read member or
  visitor changing → `forbidden`.

## 5. How it is tested

- Server: `unit/features/channels/services/channel_rules_test.dart`, note validation in
  `unit/features/patterns/services/pattern_rules_test.dart`,
  `integration/channel_endpoint_test.dart`, `integration/pattern_notes_test.dart`
  (auth, ownership, read members, visitors, validation, replace-all saves, clone copies
  notes, shrink trims notes, cascades, default rack, channel cap).
- Flutter: `metronome_test` (step reporting, clicks only on beats),
  `studio_repository_impl_test` (channel/note calls), `studio_sequencer_test` (toggle
  steps with preview, save and failures, transport playback incl. loop wrap, pitch → rate
  and velocity → volume, mute silences and reverts on failure, piano-roll notes, preview,
  shrinking drops notes, add/delete channels, read-only), `channel_rack_test`,
  `piano_roll_test` and `studio_view_test` (step → sound → debounced save, drums play on
  their steps while the transport runs, tab switching and key preview). Tests use
  `FakeAudioEngine`, which records clicks and samples instead of playing them.
