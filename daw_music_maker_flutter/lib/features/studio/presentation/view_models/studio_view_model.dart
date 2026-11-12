import 'dart:async';
import 'dart:math' as math;

import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/audio/audio_engine.dart';
import '../../../../core/audio/audio_providers.dart';
import '../../../../core/audio/metronome.dart';
import '../../../../core/audio/sound_source.dart';
import '../../../../core/audio/tap_tempo.dart';
import '../../../../core/audio/transport_position.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../data/studio_clip.dart';
import '../../data/studio_note.dart';
import '../../data/studio_providers.dart';
import '../state/sample_upload.dart';
import '../state/studio_state.dart';

part 'studio_view_model.g.dart';

/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.
@riverpod
class StudioViewModel extends _$StudioViewModel {
  final TapTempo _tapTempo = TapTempo();
  bool _resaveRequested = false;

  /// Delay before note edits are saved (edits in between are batched).
  static const noteSaveDelay = Duration(milliseconds: 600);

  final Map<UuidValue, Timer> _noteSaveTimers = {};
  Timer? _playlistSaveTimer;

  Metronome get _metronome => ref.read(metronomeProvider);
  AudioEngine get _engine => ref.read(audioEngineProvider);

  @override
  Future<StudioState> build(UuidValue projectId) async {
    // Watching keeps one metronome alive for this screen; it is disposed
    // (and stops) together with the ViewModel.
    final metronome = ref.watch(metronomeProvider);
    ref.onDispose(metronome.stop);
    metronome.onStep = _playStep;
    ref.onDispose(() {
      metronome.onStep = null;
      for (final timer in _noteSaveTimers.values) {
        timer.cancel();
      }
      _playlistSaveTimer?.cancel();
    });
    // Preload sounds so previews and the first notes play without delay.
    unawaited(ref.read(audioEngineProvider).load().catchError((_) {}));
    try {
      final repository = ref.read(studioRepositoryProvider);
      final (project, patterns, channels, clips, samples) = await (
        repository.loadProject(projectId),
        repository.listPatterns(projectId),
        repository.listChannels(projectId),
        repository.listClips(projectId),
        repository.listSamples(projectId),
      ).wait;
      metronome.bpm = project.bpm;
      final first = patterns.isEmpty ? null : patterns.first;
      final notes = first == null
          ? const <UuidValue, List<StudioNote>>{}
          : {first.id: await repository.listNotes(first.id)};
      return StudioState(
        project: project,
        bpm: project.bpm,
        savedBpm: project.bpm,
        patterns: patterns,
        selectedPatternId: first?.id,
        channels: channels,
        selectedChannelId: channels.isEmpty ? null : channels.first.id,
        notes: notes,
        clips: clips,
        samples: samples,
      );
    } on ParallelWaitError<dynamic, dynamic> catch (error) {
      final (a, b, c, d, e) =
          error.errors
              as (
                AsyncError?,
                AsyncError?,
                AsyncError?,
                AsyncError?,
                AsyncError?,
              );
      throw mapGenericError((a ?? b ?? c ?? d ?? e)?.error ?? error);
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  /// The beat currently playing (0-based in the bar), null when stopped.
  ValueListenable<int?> get beat => _metronome.beat;

  /// Absolute transport step (null when stopped), for step-grid playheads.
  ValueListenable<int?> get playhead => _metronome.step;

  /// Live playback position (for the playhead), sampled at frame rate.
  TransportPosition get position => _metronome;

  /// Mutes or unmutes the metronome clicks; playback keeps running.
  void toggleMute() {
    final current = state.value;
    if (current == null) return;
    final muted = !current.isMuted;
    _metronome.muted = muted;
    state = AsyncData(current.copyWith(isMuted: muted));
  }

  // ── Sequencer ────────────────────────────────────────────────────────────

  /// Plays the notes of the selected pattern at transport step [step]
  /// (looping over the pattern). Muted channels stay silent.
  void _playStep(int step) {
    final current = state.value;
    if (current == null) return;
    if (current.mode == TransportMode.song) {
      _playSongStep(current, step);
      return;
    }
    if (!current.notesLoaded) return;
    final channels = {for (final c in current.channels) c.id: c};
    _playNotesAt(current.currentNotes, step % current.patternSteps, channels);
  }

  /// Plays the [notes] starting on pattern step [localStep] (unmuted
  /// channels only).
  void _playNotesAt(
    List<StudioNote> notes,
    int localStep,
    Map<UuidValue, ChannelResponse> channels,
  ) {
    final from = localStep * ValidationRules.stepTicks;
    final to = from + ValidationRules.stepTicks;
    for (final note in notes) {
      if (note.tick < from || note.tick >= to) continue;
      final channel = channels[note.channelId];
      if (channel == null || channel.muted) continue;
      _playNote(channel, note.pitch, note.velocity);
    }
  }

  void _playNote(ChannelResponse channel, int pitch, int velocity) {
    final source = _sourceOf(channel);
    if (source == null) return;
    _engine.play(
      source,
      volume: channel.volume * velocity / 127,
      rate: rateForPitch(pitch + channel.pitch),
      pan: channel.pan,
      startFrac: channel.startFrac,
      endFrac: channel.endFrac,
    );
  }

  /// Playback rate that transposes a sample from C5 (60) to [pitch].
  static double rateForPitch(int pitch) =>
      math.pow(2, (pitch - ValidationRules.rootPitch) / 12).toDouble();

  /// Shows the channel rack or the piano roll.
  void setWorkspace(StudioWorkspace workspace) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(workspace: workspace));
  }

  /// Selects the channel shown in the piano roll.
  void selectChannel(UuidValue channelId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedChannelId: channelId));
  }

  /// Opens [channelId] in the piano roll.
  void openPianoRoll(UuidValue channelId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        selectedChannelId: channelId,
        workspace: StudioWorkspace.pianoRoll,
      ),
    );
  }

  /// Plays [channelId] at [pitch] (piano keys, new notes). Allowed for
  /// everyone, including read-only users.
  void preview(UuidValue channelId, {int pitch = ValidationRules.rootPitch}) {
    final channel = state.value?.channels
        .where((c) => c.id == channelId)
        .firstOrNull;
    if (channel != null) {
      _playNote(channel, pitch, ValidationRules.defaultVelocity);
    }
  }

  /// Turns the step [step] of [channelId] on (root-pitch note, previewed)
  /// or off (removes the channel's notes starting on that step).
  void toggleStep(UuidValue channelId, int step) {
    final current = state.value;
    if (current == null || !current.canEdit || !current.notesLoaded) return;
    final notes = current.currentNotes;
    final onStep = [
      for (final n in notes)
        if (n.channelId == channelId && n.step == step) n,
    ];
    if (onStep.isNotEmpty) {
      _setCurrentNotes([
        for (final n in notes)
          if (!onStep.contains(n)) n,
      ]);
    } else {
      if (notes.length >= ValidationRules.notesPerPatternMax) return;
      _setCurrentNotes([
        ...notes,
        StudioNote(
          channelId: channelId,
          tick: step * ValidationRules.stepTicks,
        ),
      ]);
      preview(channelId);
    }
  }

  /// Piano roll click at [step] / [pitch] for the selected channel: removes
  /// the note sounding there, or adds a one-step note (previewed).
  void togglePianoNote(int step, int pitch) {
    final current = state.value;
    final channel = current?.selectedChannel;
    if (current == null ||
        channel == null ||
        !current.canEdit ||
        !current.notesLoaded) {
      return;
    }
    final tick = step * ValidationRules.stepTicks;
    final notes = current.currentNotes;
    final hit = notes
        .where(
          (n) =>
              n.channelId == channel.id && n.pitch == pitch && n.covers(tick),
        )
        .firstOrNull;
    if (hit != null) {
      _setCurrentNotes([
        for (final n in notes)
          if (n != hit) n,
      ]);
    } else {
      if (notes.length >= ValidationRules.notesPerPatternMax) return;
      _setCurrentNotes([
        ...notes,
        StudioNote(channelId: channel.id, tick: tick, pitch: pitch),
      ]);
      preview(channel.id, pitch: pitch);
    }
  }

  void _setCurrentNotes(List<StudioNote> notes) {
    final current = state.value!;
    final patternId = current.selectedPattern!.id;
    state = AsyncData(
      current.copyWith(
        notes: {...current.notes, patternId: notes},
        notesDirty: true,
        failure: null,
      ),
    );
    _noteSaveTimers[patternId]?.cancel();
    _noteSaveTimers[patternId] = Timer(
      noteSaveDelay,
      () => unawaited(saveNotes(patternId)),
    );
  }

  /// Saves the notes of [patternId] now (normally called after
  /// [noteSaveDelay] of inactivity).
  Future<void> saveNotes(UuidValue patternId) async {
    _noteSaveTimers.remove(patternId)?.cancel();
    final notes = state.value?.notes[patternId];
    if (notes == null || !(state.value?.canEdit ?? false)) return;
    try {
      await ref.read(studioRepositoryProvider).saveNotes(patternId, notes);
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(notesDirty: _noteSaveTimers.isNotEmpty),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(failure: mapGenericError(error)),
      );
    }
  }

  /// Mutes or unmutes a channel (saved).
  Future<void> toggleChannelMute(UuidValue channelId) =>
      _updateChannel(channelId, (c) => c.copyWith(muted: !c.muted));

  /// Sets a channel's volume locally while dragging (call
  /// [commitChannelVolume] when done).
  void setChannelVolume(UuidValue channelId, double volume) =>
      setSamplerSettings(channelId, volume: volume);

  /// Saves a channel's current volume.
  Future<void> commitChannelVolume(UuidValue channelId) =>
      commitChannel(channelId);

  /// Adds a channel playing [sample] at the end of the rack.
  Future<void> addChannel(SampleKind sample) async {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    try {
      final created = await ref
          .read(studioRepositoryProvider)
          .createChannel(projectId, sample: sample);
      if (!ref.mounted) return;
      final latest = state.value!;
      state = AsyncData(
        latest.copyWith(channels: [...latest.channels, created]),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
    }
  }

  /// Deletes a channel and its notes (in every pattern).
  Future<void> deleteChannel(UuidValue channelId) async {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    try {
      await ref.read(studioRepositoryProvider).deleteChannel(channelId);
      if (!ref.mounted) return;
      final latest = state.value!;
      state = AsyncData(
        latest.copyWith(
          channels: [
            for (final c in latest.channels)
              if (c.id != channelId) c,
          ],
          notes: {
            for (final e in latest.notes.entries)
              e.key: [
                for (final n in e.value)
                  if (n.channelId != channelId) n,
              ],
          },
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
    }
  }

  /// Applies [change] to a channel optimistically and saves all of its
  /// settings; restores the previous rack if the server refuses.
  Future<void> _updateChannel(
    UuidValue channelId,
    ChannelResponse Function(ChannelResponse c) change,
  ) async {
    final current = state.value;
    final channel = current?.channels
        .where((c) => c.id == channelId)
        .firstOrNull;
    if (current == null || channel == null || !current.canEdit) return;
    final next = change(channel);
    state = AsyncData(
      current.copyWith(
        channels: [
          for (final c in current.channels) c.id == channelId ? next : c,
        ],
      ),
    );
    try {
      final saved = await ref
          .read(studioRepositoryProvider)
          .updateChannel(
            channelId,
            name: next.name,
            volume: next.volume,
            muted: next.muted,
            pan: next.pan,
            pitch: next.pitch,
            startFrac: next.startFrac,
            endFrac: next.endFrac,
          );
      if (!ref.mounted) return;
      final latest = state.value!;
      state = AsyncData(
        latest.copyWith(
          channels: [
            for (final c in latest.channels) c.id == saved.id ? saved : c,
          ],
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          channels: current.channels,
          failure: mapGenericError(error),
        ),
      );
    }
  }

  // ── Playlist / song mode ─────────────────────────────────────────────────

  /// Switches PAT (loop the pattern) / SONG (play the playlist). Patterns
  /// used by the playlist get their notes loaded for song playback.
  void setMode(TransportMode mode) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(mode: mode));
    if (mode == TransportMode.song) unawaited(_ensureClipNotes());
  }

  /// Flips between PAT and SONG.
  void toggleMode() {
    final current = state.value;
    if (current == null) return;
    setMode(
      current.mode == TransportMode.pattern
          ? TransportMode.song
          : TransportMode.pattern,
    );
  }

  /// Playlist click on [track] / [bar]: removes the clip there, or places the
  /// selected pattern starting at [bar] if it fits (no overlap on the track,
  /// within the song limit).
  void togglePlaylistCell(int track, int bar) {
    final current = state.value;
    final pattern = current?.selectedPattern;
    if (current == null || pattern == null || !current.canEdit) return;
    final hit = current.clipAt(track, bar);
    if (hit != null) {
      _setClips([
        for (final c in current.clips)
          if (c != hit) c,
      ]);
      return;
    }
    final clip = StudioClip(patternId: pattern.id, track: track, startBar: bar);
    if (_fits(current, clip)) _setClips([...current.clips, clip]);
  }

  /// Selects the pattern of the clip at [track] / [bar] (FL: pick a clip's
  /// pattern to edit it). Audio clips are previewed instead.
  void selectClipPattern(int track, int bar) {
    final clip = state.value?.clipAt(track, bar);
    if (clip == null) return;
    final patternId = clip.patternId;
    if (patternId != null) {
      selectPattern(patternId);
    } else {
      previewSound(sampleId: clip.sampleId);
    }
  }

  void _setClips(List<StudioClip> clips) {
    final current = state.value!;
    state = AsyncData(
      current.copyWith(clips: clips, playlistDirty: true, failure: null),
    );
    _playlistSaveTimer?.cancel();
    _playlistSaveTimer = Timer(
      noteSaveDelay,
      () => unawaited(savePlaylist()),
    );
  }

  /// Saves the playlist now (normally after [noteSaveDelay] of inactivity).
  Future<void> savePlaylist() async {
    _playlistSaveTimer?.cancel();
    _playlistSaveTimer = null;
    final current = state.value;
    if (current == null || !current.canEdit) return;
    try {
      await ref
          .read(studioRepositoryProvider)
          .saveClips(projectId, current.clips);
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(playlistDirty: _playlistSaveTimer != null),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
    }
  }

  /// Loads the notes of every pattern used in the playlist.
  Future<void> _ensureClipNotes() async {
    final clips = state.value?.clips ?? const <StudioClip>[];
    for (final id in {
      for (final c in clips)
        if (c.patternId != null) c.patternId!,
    }) {
      await _ensureNotes(id);
    }
  }

  /// Song mode: plays every clip sounding at song step [step].
  void _playSongStep(StudioState current, int step) {
    const stepsPerBar = ValidationRules.stepsPerBar;
    final songStep = step % (current.songBars * stepsPerBar);
    final bar = songStep ~/ stepsPerBar;
    final channels = {for (final c in current.channels) c.id: c};
    for (final clip in current.clips) {
      final length = current.clipLength(clip);
      if (bar < clip.startBar || bar >= clip.startBar + length) continue;
      if (clip.isAudio) {
        // Audio clips start their file on their first step.
        final sample = current.sampleById(clip.sampleId);
        if (sample != null && songStep == clip.startBar * stepsPerBar) {
          _engine.play(UploadedSound(sample.id, sample.url), volume: 0.8);
        }
        continue;
      }
      final notes = current.notes[clip.patternId];
      if (notes == null) continue;
      final local = songStep - clip.startBar * stepsPerBar;
      _playNotesAt(notes, local, channels);
    }
  }

  /// After a pattern grows, drops clips that now overlap or pass the song
  /// limit (earlier clips win), and saves the playlist if anything changed.
  void _resolveClipOverlaps() {
    final current = state.value;
    if (current == null) return;
    final kept = <StudioClip>[];
    final sorted = [...current.clips]
      ..sort((a, b) => a.startBar.compareTo(b.startBar));
    for (final c in sorted) {
      final end = c.startBar + current.clipLength(c);
      final overlaps = kept.any(
        (k) =>
            k.track == c.track &&
            c.startBar < k.startBar + current.clipLength(k) &&
            k.startBar < end,
      );
      if (!overlaps && end <= ValidationRules.playlistBarsMax) kept.add(c);
    }
    if (kept.length != current.clips.length) _setClips(kept);
  }

  // ── Samples (uploads, browser, sampler) ──────────────────────────────────

  int _uploadSeq = 0;

  /// The sound a channel plays.
  SoundSource? _sourceOf(ChannelResponse channel) {
    final sampleId = channel.sampleId;
    if (sampleId != null) {
      final sample = state.value?.sampleById(sampleId);
      return sample == null ? null : UploadedSound(sample.id, sample.url);
    }
    final kind = channel.sample;
    return kind == null ? null : BuiltinSound(kind);
  }

  /// Uploads audio [files] (name + bytes) one after another, each with a
  /// progress entry. Files failing the client checks (type, ≤ 10 MB) are
  /// listed with their error without contacting the server.
  Future<void> uploadFiles(List<({String name, Uint8List bytes})> files) async {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    for (final file in files) {
      final id = ++_uploadSeq;
      final error = Validators.audioFile(file.name, file.bytes.length);
      _putUpload(SampleUpload(id: id, fileName: file.name, error: error));
      if (error != null) continue;
      try {
        final sample = await ref
            .read(studioRepositoryProvider)
            .uploadSample(
              projectId,
              fileName: file.name,
              bytes: file.bytes,
              onProgress: (p) =>
                  _updateUpload(id, (u) => u.copyWith(progress: p)),
            );
        if (!ref.mounted) return;
        final latest = state.value!;
        state = AsyncData(
          latest.copyWith(
            samples: [sample, ...latest.samples],
            uploads: [
              for (final u in latest.uploads)
                if (u.id != id) u,
            ],
          ),
        );
      } catch (e) {
        if (!ref.mounted) return;
        final failure = mapGenericError(e);
        _updateUpload(
          id,
          (u) => u.copyWith(
            failure: failure,
            error: failure.fieldErrors.values.firstOrNull ?? failure.message,
          ),
        );
      }
    }
  }

  void _putUpload(SampleUpload upload) {
    final current = state.value!;
    state = AsyncData(current.copyWith(uploads: [...current.uploads, upload]));
  }

  void _updateUpload(int id, SampleUpload Function(SampleUpload) change) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        uploads: [
          for (final u in current.uploads) u.id == id ? change(u) : u,
        ],
      ),
    );
  }

  /// Removes a finished / failed upload entry.
  void dismissUpload(int id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        uploads: [
          for (final u in current.uploads)
            if (u.id != id) u,
        ],
      ),
    );
  }

  /// Plays a browser item: a built-in [kind] or an uploaded [sampleId].
  void previewSound({SampleKind? kind, UuidValue? sampleId}) {
    if (kind != null) {
      _engine.play(BuiltinSound(kind), volume: 0.8);
      return;
    }
    final sample = state.value?.sampleById(sampleId);
    if (sample != null) {
      _engine.play(UploadedSound(sample.id, sample.url), volume: 0.8);
    }
  }

  /// Deletes an uploaded sample; channels and clips using it go too (the
  /// server cascades, mirrored here).
  Future<void> deleteSample(UuidValue sampleId) async {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    try {
      await ref.read(studioRepositoryProvider).deleteSample(sampleId);
      if (!ref.mounted) return;
      final latest = state.value!;
      final removedChannels = {
        for (final c in latest.channels)
          if (c.sampleId == sampleId) c.id,
      };
      state = AsyncData(
        latest.copyWith(
          samples: [
            for (final s in latest.samples)
              if (s.id != sampleId) s,
          ],
          channels: [
            for (final c in latest.channels)
              if (!removedChannels.contains(c.id)) c,
          ],
          notes: {
            for (final e in latest.notes.entries)
              e.key: [
                for (final n in e.value)
                  if (!removedChannels.contains(n.channelId)) n,
              ],
          },
          clips: [
            for (final c in latest.clips)
              if (c.sampleId != sampleId) c,
          ],
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
    }
  }

  /// Adds a channel playing a built-in [kind] or an uploaded [sampleId];
  /// returns the new channel's id (null on failure or read-only).
  Future<UuidValue?> addChannelFor({
    SampleKind? kind,
    UuidValue? sampleId,
  }) async {
    final current = state.value;
    if (current == null || !current.canEdit) return null;
    try {
      final created = await ref
          .read(studioRepositoryProvider)
          .createChannel(projectId, sample: kind, sampleId: sampleId);
      if (!ref.mounted) return null;
      final latest = state.value!;
      state = AsyncData(
        latest.copyWith(
          channels: [...latest.channels, created],
          selectedChannelId: created.id,
        ),
      );
      return created.id;
    } catch (error) {
      if (!ref.mounted) return null;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
      return null;
    }
  }

  /// Changes sampler settings locally (heard on the next note / preview);
  /// call [commitChannel] when the gesture ends.
  void setSamplerSettings(
    UuidValue channelId, {
    double? volume,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  }) {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    state = AsyncData(
      current.copyWith(
        channels: [
          for (final c in current.channels)
            if (c.id != channelId)
              c
            else
              () {
                var start = (startFrac ?? c.startFrac).clamp(0.0, 1.0);
                var end = (endFrac ?? c.endFrac).clamp(0.0, 1.0);
                // Keep a minimal region; the dragged handle yields.
                if (end - start < ValidationRules.regionMinFrac) {
                  if (startFrac != null) {
                    start = end - ValidationRules.regionMinFrac;
                  } else {
                    end = start + ValidationRules.regionMinFrac;
                  }
                }
                return c.copyWith(
                  volume: (volume ?? c.volume).clamp(0.0, 1.0),
                  pan: (pan ?? c.pan).clamp(-1.0, 1.0),
                  pitch: (pitch ?? c.pitch).clamp(
                    -ValidationRules.samplerPitchRange,
                    ValidationRules.samplerPitchRange,
                  ),
                  startFrac: start,
                  endFrac: end,
                );
              }(),
        ],
      ),
    );
  }

  /// Saves a channel's current settings.
  Future<void> commitChannel(UuidValue channelId) =>
      _updateChannel(channelId, (c) => c);

  /// Chops a channel's region into [slices] new channels (appended to the
  /// rack, ready for the step sequencer).
  Future<void> chopChannel(UuidValue channelId, int slices) async {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    try {
      final created = await ref
          .read(studioRepositoryProvider)
          .chopChannel(channelId, slices);
      if (!ref.mounted) return;
      final latest = state.value!;
      state = AsyncData(
        latest.copyWith(channels: [...latest.channels, ...created]),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(failure: mapGenericError(error)));
    }
  }

  /// Bars an audio clip of [sample] lasts at the current tempo (1–64).
  int audioClipBars(SampleResponse sample) {
    final ms = sample.durationMs;
    final bpm = state.value?.bpm ?? 120;
    if (ms == null || ms <= 0) return 1;
    // One bar lasts 4 beats = 240000 / bpm milliseconds.
    return (ms * bpm / 240000).ceil().clamp(
      1,
      ValidationRules.audioClipBarsMax,
    );
  }

  /// Places an audio clip of [sampleId] on [track] at [bar] if it fits.
  void placeSampleClip(UuidValue sampleId, int track, int bar) {
    final current = state.value;
    final sample = current?.sampleById(sampleId);
    if (current == null || sample == null || !current.canEdit) return;
    final clip = StudioClip(
      sampleId: sampleId,
      lengthBars: audioClipBars(sample),
      track: track,
      startBar: bar,
    );
    if (_fits(current, clip)) _setClips([...current.clips, clip]);
  }

  /// Whether [clip] fits: within the song limit, under the clip cap, and not
  /// overlapping another clip on its track.
  bool _fits(StudioState current, StudioClip clip) {
    final end = clip.startBar + current.clipLength(clip);
    return end <= ValidationRules.playlistBarsMax &&
        current.clips.length < ValidationRules.playlistClipsMax &&
        !current.clips.any(
          (c) =>
              c.track == clip.track &&
              clip.startBar < c.startBar + current.clipLength(c) &&
              c.startBar < end,
        );
  }

  // ── Patterns ─────────────────────────────────────────────────────────────

  /// Selects a pattern (local to this user; changes the timeline loop).
  void selectPattern(UuidValue patternId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedPatternId: patternId));
    unawaited(_ensureNotes(patternId));
  }

  /// Loads a pattern's notes the first time it is opened.
  Future<void> _ensureNotes(UuidValue patternId) async {
    if (state.value?.notes.containsKey(patternId) ?? true) return;
    try {
      final notes = await ref
          .read(studioRepositoryProvider)
          .listNotes(patternId);
      if (!ref.mounted) return;
      final current = state.value!;
      state = AsyncData(
        current.copyWith(notes: {...current.notes, patternId: notes}),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(failure: mapGenericError(error)),
      );
    }
  }

  /// Selects the next (+1) or previous (−1) pattern, wrapping around.
  void stepPattern(int direction) {
    final current = state.value;
    if (current == null || current.patterns.isEmpty) return;
    final patterns = current.patterns;
    final index = patterns.indexWhere(
      (p) => p.id == current.selectedPattern?.id,
    );
    final next = (index + direction) % patterns.length;
    selectPattern(patterns[next < 0 ? next + patterns.length : next].id);
  }

  /// Adds a pattern ("Pattern N") and selects it.
  Future<void> createPattern() => _patternAction(() async {
    final created = await ref
        .read(studioRepositoryProvider)
        .createPattern(projectId);
    return (patterns: [...state.value!.patterns, created], select: created.id);
  });

  /// Duplicates the selected pattern and selects the copy.
  Future<void> cloneSelectedPattern() => _patternAction(() async {
    final source = state.value!.selectedPattern!;
    final copy = await ref
        .read(studioRepositoryProvider)
        .clonePattern(source.id);
    return (patterns: [...state.value!.patterns, copy], select: copy.id);
  });

  /// Renames the selected pattern.
  Future<void> renameSelectedPattern(String name) => _updateSelected(
    (p) => (name: name, colorIndex: p.colorIndex, lengthBars: p.lengthBars),
  );

  /// Recolors the selected pattern.
  Future<void> setSelectedPatternColor(int colorIndex) => _updateSelected(
    (p) => (name: p.name, colorIndex: colorIndex, lengthBars: p.lengthBars),
  );

  /// Changes the selected pattern's length (the timeline loop follows).
  Future<void> setSelectedPatternLength(int bars) async {
    await _updateSelected(
      (p) => (name: p.name, colorIndex: p.colorIndex, lengthBars: bars),
    );
    // A longer pattern can make playlist clips overlap.
    _resolveClipOverlaps();
    // Mirror the server: notes beyond the new length are dropped.
    final current = state.value;
    final pattern = current?.selectedPattern;
    if (current == null || pattern == null || pattern.lengthBars != bars) {
      return;
    }
    final limit = bars * ValidationRules.ticksPerBar;
    final notes = current.notes[pattern.id];
    if (notes == null) return;
    state = AsyncData(
      current.copyWith(
        notes: {
          ...current.notes,
          pattern.id: [
            for (final n in notes)
              if (n.tick < limit) n,
          ],
        },
      ),
    );
  }

  /// Deletes the selected pattern and selects its neighbor. The server
  /// refuses to delete the last pattern.
  Future<void> deleteSelectedPattern() => _patternAction(() async {
    final current = state.value!;
    final target = current.selectedPattern!;
    await ref.read(studioRepositoryProvider).deletePattern(target.id);
    final index = current.patterns.indexWhere((p) => p.id == target.id);
    final remaining = [...current.patterns]..removeAt(index);
    final neighbor = remaining.isEmpty
        ? null
        : remaining[index.clamp(0, remaining.length - 1)].id;
    // The server deletes the pattern's clips with it; mirror that.
    final latest = state.value!;
    if (latest.clips.any((c) => c.patternId == target.id)) {
      state = AsyncData(
        latest.copyWith(
          clips: [
            for (final c in latest.clips)
              if (c.patternId != target.id) c,
          ],
        ),
      );
    }
    return (patterns: remaining, select: neighbor);
  });

  Future<void> _updateSelected(
    ({String name, int colorIndex, int lengthBars}) Function(
      PatternResponse pattern,
    )
    change,
  ) => _patternAction(() async {
    final current = state.value!;
    final target = current.selectedPattern!;
    final next = change(target);
    final saved = await ref
        .read(studioRepositoryProvider)
        .updatePattern(
          target.id,
          name: next.name,
          colorIndex: next.colorIndex,
          lengthBars: next.lengthBars,
        );
    return (
      patterns: [
        for (final p in current.patterns) p.id == saved.id ? saved : p,
      ],
      select: saved.id,
    );
  });

  /// Runs a pattern change for editors: busy flag, error handling, and the
  /// resulting list + selection.
  Future<void> _patternAction(
    Future<({List<PatternResponse> patterns, UuidValue? select})> Function()
    action,
  ) async {
    final current = state.value;
    if (current == null ||
        !current.canEdit ||
        current.isPatternBusy ||
        current.selectedPattern == null && current.patterns.isNotEmpty) {
      return;
    }
    state = AsyncData(current.copyWith(isPatternBusy: true, failure: null));
    try {
      final result = await action();
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isPatternBusy: false,
          patterns: result.patterns,
          selectedPatternId: result.select,
        ),
      );
      // New / cloned / neighbor patterns need their notes.
      final selected = result.select;
      if (selected != null) unawaited(_ensureNotes(selected));
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isPatternBusy: false,
          failure: mapGenericError(error),
        ),
      );
    }
  }

  /// Clamps [bpm] to the allowed range and rounds it to 2 decimals.
  static double normalize(double bpm) =>
      (bpm.clamp(ValidationRules.bpmMin, ValidationRules.bpmMax) * 100)
          .roundToDouble() /
      100;

  /// Changes the tempo locally (heard immediately). Call [save] to persist.
  /// Ignored for read-only users.
  void setBpm(double bpm) {
    final current = state.value;
    if (current == null || !current.canEdit) return;
    final value = normalize(bpm);
    _metronome.bpm = value;
    state = AsyncData(current.copyWith(bpm: value, failure: null));
  }

  /// Changes the tempo by [delta] BPM without saving — used while the user
  /// holds the BPM display and scrolls or drags; [save] runs on release.
  void adjust(double delta) {
    final current = state.value;
    if (current == null) return;
    setBpm(current.bpm + delta);
  }

  /// Changes the tempo by [delta] BPM and saves it.
  Future<void> nudge(double delta) async {
    final current = state.value;
    if (current == null) return;
    setBpm(current.bpm + delta);
    await save();
  }

  /// Registers a tap; after two taps the tempo follows the tapping and is
  /// saved.
  Future<void> tap() async {
    final bpm = _tapTempo.tap();
    if (bpm == null) return;
    setBpm(bpm);
    await save();
  }

  /// Starts or stops the metronome at the current tempo.
  Future<void> togglePlay() async {
    final current = state.value;
    if (current == null) return;
    if (current.isPlaying) {
      _metronome.stop();
      state = AsyncData(current.copyWith(isPlaying: false));
    } else {
      state = AsyncData(current.copyWith(isPlaying: true));
      await _metronome.start(current.bpm);
    }
  }

  /// Persists the current tempo if it changed. While a save is in flight,
  /// one more save is queued so the last value always wins.
  Future<void> save() async {
    final current = state.value;
    if (current == null || !current.canEdit || !current.isDirty) return;
    if (current.isSaving) {
      _resaveRequested = true;
      return;
    }
    state = AsyncData(current.copyWith(isSaving: true, failure: null));
    try {
      final saved = await ref
          .read(studioRepositoryProvider)
          .saveTempo(projectId, current.bpm);
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isSaving: false,
          savedBpm: saved.bpm,
          project: saved,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(
          isSaving: false,
          failure: mapGenericError(error),
        ),
      );
      _resaveRequested = false;
      return;
    }
    if (_resaveRequested) {
      _resaveRequested = false;
      await save();
    }
  }
}
