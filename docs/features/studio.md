# Studio — tempo (BPM) and metronome

## 1. Purpose and user stories

The studio is where a project is produced. Its first piece is the transport:

- From a project page I tap **Go to studio** and land on `/projects/{projectId}/studio`.
- As an owner or write member I set the project's **tempo** (BPM) in the transport
  toolbar: **hold the BPM display and roll the mouse wheel** (±1 per notch, ±0.1 with
  Shift; wheel up = faster), **hold and drag** up/down (1 BPM per 4 px — for trackpads and
  touch), **double-click** it to type an exact value (20–999, decimals allowed), the ▲▼
  arrows, **TAP** tempo, or ↑/↓ keys. The tempo is **saved on the project** (on release)
  so every collaborator hears the same groove.
- As anyone who can open the project (including read members and visitors of public
  projects) I **play / pause a metronome** at the project's tempo (button or Space) and see
  the beat on four lights; beat 1 is accented (higher click, red light).
- I can **mute / unmute the metronome sound** (speaker toggle — selected = sound on — or
  **M**); while muted the beat, lights and playhead keep running silently.
- I see the **timeline**: a 4-bar loop with a moving playhead, a waveform trail of the
  clicks played (taller on beat 1, faded when muted). One header row shows the loop label,
  the **bar · beat** position and the **elapsed time** (`mm:ss.cc`); on narrow screens the
  texts shrink instead of wrapping.
- The studio is full screen (no app bar); the toolbar's **back arrow + project name**
  returns to the project page (`/projects/{id}`).

## 2. Screens / routes and endpoints

| Route                     | View         | ViewModel                       |
| ------------------------- | ------------ | ------------------------------- |
| `/projects/:id/studio`    | `StudioView` | `StudioViewModel(projectId)`    |

The project detail screen (`ProjectDetailView`) shows a **Go to studio** button to everyone
who can see the project. Invalid UUIDs show `NotFoundView`.

Server: `client.project.getById` (load) and `client.project.updateTempo(projectId,
UpdateProjectTempoRequest)` — owner and write members only.

Flutter structure:

- `core/audio/` — `AudioEngine` (interface) + `AudioEngineImpl` (`audioplayers` `AudioPool`s
  of preloaded clicks), `Metronome` (drift-corrected scheduling, `beat` listenable, live
  tempo changes), `TapTempo`, `metronomeProvider` (a fresh metronome per studio, disposed
  and stopped with it).
- `features/studio/data/` — `StudioRepository` (`loadProject`, `saveTempo`).
- `features/studio/presentation/` — `StudioState` (incl. `isMuted`), `StudioViewModel`
  (`toggleMute`, `position`), `StudioView` (no app bar; loading/error states keep a back
  arrow), widgets `TransportToolbar` (back + project name, play/pause, sound toggle,
  `BpmDisplay`, ▲▼, compact `BeatLights`, TAP icon, `SaveStatusChip`, theme toggle — the
  controls scroll sideways when space runs out while the status and theme toggle stay
  pinned, so it never overflows), `PlaybackTimeline` and `PlayButton`. Below the timeline
  is the workspace where the channel rack and playlist will go.

`PlaybackTimeline` reads a `TransportPosition` (implemented by `Metronome`: `isRunning`,
`elapsed`, continuous `beatPosition`) every frame with a `Ticker` that only runs while
playing, and repaints a `CustomPainter` through a frame notifier — no provider rebuilds.

`BpmDisplay` details: it tracks the press with a `Listener`; wheel events are only used
while pressed and are claimed via `GestureBinding.pointerSignalResolver`, so the page does
not scroll at the same time (without holding, the wheel scrolls the page as usual). Live
changes call `StudioViewModel.adjust` (no save); releasing calls `save`. It has no tooltip
on purpose (it would cover the number while adjusting) — the hint is shown below the
toolbar and as a semantics hint.
- Assets: `assets/audio/samples/metronome_accent.wav` and `metronome_beat.wav` (synthesized
  60 ms clicks, 44.1 kHz mono), accessed via flutter_gen (`Assets.audio.samples.*`).

Keyboard: Space play/pause, M mute, ↑/↓ nudge (ignored while typing in a field).

Timing: each beat is scheduled from the time of the previous beat using `clock` (so drift
does not accumulate and tests control time with `fakeAsync`). Changing the tempo while
playing reschedules the next beat from the last one, so the change is heard immediately.
The metronome is 4/4. Painting reacts to the `beat` listenable, not to provider rebuilds.

Saving: releasing the BPM display, ▲▼, ↑/↓, tap tempo and submitting the exact value save
the tempo.
If the tempo changes while a save is in flight, one more save runs afterwards so the latest
value wins. A status chip shows SAVED / SAVING / UNSAVED / READ ONLY.

## 3. Models

- `Project.bpm: double` (default 120.0) — column added by migration `20261111135758374`
  (non-destructive `ADD COLUMN … DEFAULT 120.0`).
- `ProjectResponse.bpm`.
- DTO `UpdateProjectTempoRequest { bpm }`.

## 4. Validation rules and security notes

- Tempo: 20–999 BPM, finite, rounded to 2 decimals on the server (`ProjectRules.validateBpm`
  → `AppException(validation, fieldErrors: {'bpm': …})`). Mirrored as
  `ValidationRules.bpmMin/bpmMax` and `Validators.bpm` in Flutter; the ViewModel also clamps.
- `updateTempo`: not visible → `notFound`; read member / visitor → `forbidden`.
- Browsers only allow audio after a user gesture; pressing Play is that gesture.

## 5. How it is tested

- Server: `unit/features/projects/services/project_rules_test.dart` (`validateBpm`),
  `integration/project_tempo_test.dart` (default 120, unauthenticated, other user's
  project, owner and write member save with rounding, read member forbidden, out-of-range,
  boundaries).
- Flutter unit: `core/audio/metronome_test.dart` (intervals, accents every 4 beats, beat
  positions, live tempo change, stop, double start, stop during load, muted beats,
  elapsed / beatPosition — all with `fakeAsync`), `core/audio/tap_tempo_test.dart`, `Validators.bpm`,
  `features/studio/data/studio_repository_impl_test.dart`,
  `features/studio/presentation/view_models/studio_view_model_test.dart`.
- Flutter widget: `studio_view_test.dart` (play/pause clicks and lights, Space, arrows and
  ↓, hold + wheel saves once on release, double-click typing, tap tempo, save failure,
  read-only, not found, Go to studio from the project page), `bpm_display_test.dart`
  (hold + wheel without page scroll, Shift fine-tune, wheel without hold scrolls the page,
  hold + drag, double-click validation, disabled) and `studio_widgets_test.dart`
  (toolbar back, sound toggle selected/not, TAP icon, no overflow at 320/640/860 px,
  read-only, unsaved; beat lights, play button), `playback_timeline_test.dart` (time and
  bar/beat formatting, stopped state, per-frame updates, loop wrap). `studio_view_test`
  also checks there is no AppBar, back returns to `/projects/{id}`, muted playback lights
  pads without clicks (M unmutes), and the timeline's elapsed time while playing. Tests use
  `FakeAudioEngine` (`test/helpers/fakes.dart`); no real audio plays.
