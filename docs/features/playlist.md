# Playlist — song arrangement (FL Studio style)

## 1. Purpose and user stories

The playlist arranges a project's patterns into a song, like FL Studio's playlist.

- In the studio's **Playlist** tab I see 16 tracks over bars (32 shown, growing with the
  song). Clicking an empty cell places the **selected pattern** there (FL's paint tool);
  clicking a clip removes it; right-click / long-press a clip selects its pattern so I can
  edit it in the channel rack or piano roll.
- Clips are drawn in their pattern's color with its name and last as long as the pattern.
  **Audio clips** (uploads dragged from the browser, see [samples.md](samples.md)) show
  the sample's waveform and last `lengthBars`; they start their file on their first bar.
  Clips on one track can't overlap; the song can be up to 256 bars.
- The toolbar's **PAT / SONG** switch (or **L**) chooses what play does: PAT loops the
  selected pattern, SONG plays the arrangement from bar 1 and loops at its end. In SONG
  mode the timeline shows `SONG · LOOP N BARS` and a playhead runs across the playlist.
- The playlist starts empty and is saved automatically 600 ms after the last edit.
- Read members and visitors can play the song and switch modes but not edit.

## 2. Screens / routes and endpoints

- Studio (`/projects/:id/studio`): `PlaylistView` (third workspace tab), PAT/SONG
  `DawSegmentedControl` in `TransportToolbar`, `L` shortcut.
- Server `client.playlist` (`PlaylistEndpoint`, `requireLogin`): `list(projectId)` (visible
  project) and `save(projectId, SavePlaylistRequest)` (owner / write member; replaces the
  whole playlist in a transaction).
- Flutter: `StudioClip` (freezed), `StudioRepository.listClips / saveClips`,
  `StudioState.mode / clips / playlistDirty / songBars / loopBars / clipAt`,
  `StudioViewModel.setMode / toggleMode / togglePlaylistCell / selectClipPattern /
  savePlaylist`. In SONG mode `_playSongStep` plays, for every clip sounding at the song
  step, its pattern's notes at the local step; the notes of all patterns used by the
  playlist are loaded when switching to SONG.
- Consistency: deleting a pattern removes its clips (server cascade, mirrored locally);
  making a pattern longer drops later clips it would now overlap (earlier clips win) and
  saves the playlist.

## 3. Models

- Entity `PlaylistClip` (`playlist_clip`): `projectId` (cascade), `patternId` (cascade),
  `track`, `startBar`.
- DTOs `ClipInput { patternId, track, startBar }`, `SavePlaylistRequest { clips }`;
  response `ClipResponse`.
- Migration `20261111172234764` creates the table.

## 4. Validation rules and security notes

| Rule              | Value                                                   |
| ----------------- | ------------------------------------------------------- |
| Tracks            | 16 (0–15)                                               |
| Song length       | clips must end by bar 256                               |
| Overlaps          | not allowed on the same track (clip length = pattern)  |
| Clips             | ≤ 2048 (`limitReached`)                                 |
| Patterns          | must belong to the project (else `validation`)          |

Not visible → `notFound`; read member / visitor saving → `forbidden`.

## 5. How it is tested

- Server: `unit/features/playlist/services/playlist_rules_test.dart` (ranges, overlaps,
  adjacency, cap, error index) and `integration/playlist_endpoint_test.dart` (auth,
  ownership, read members, visitors, validation incl. foreign patterns, replace-all,
  empty start, cascades on pattern and project delete).
- Flutter: repository mapping (`studio_repository_impl_test`), `studio_playlist_test`
  (load, song length, PAT/SONG loop, place / remove / reject overlaps and overflow,
  right-click selects the pattern, save and failures, song playback at clip bars incl.
  loop, PAT ignores the playlist, pattern delete removes clips, growing a pattern drops
  overlapped clips, read-only), `playlist_view_test` and `studio_view_test` (place a clip
  → debounced save, `L` / PAT switch updates the timeline, song playback timing).
