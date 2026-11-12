import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../data/studio_clip.dart';
import '../../data/studio_note.dart';
import 'sample_upload.dart';

part 'studio_state.freezed.dart';

/// What the workspace below the timeline shows.
enum StudioWorkspace {
  /// FL-style step sequencer: one row of steps per channel.
  channelRack,

  /// Notes of the selected channel on a pitch × time grid.
  pianoRoll,

  /// The song arrangement: patterns placed on tracks over bars.
  playlist,
}

/// What the transport plays (FL Studio's PAT / SONG switch).
enum TransportMode {
  /// Loop the selected pattern.
  pattern,

  /// Play the playlist arrangement from bar 1.
  song,
}

/// UI state of the studio screen.
@freezed
abstract class StudioState with _$StudioState {
  /// Creates the state.
  const factory StudioState({
    /// The project open in the studio.
    required ProjectResponse project,

    /// Current tempo (may be ahead of [savedBpm] while editing).
    required double bpm,

    /// Last tempo stored on the server.
    required double savedBpm,

    /// Whether the metronome is playing.
    @Default(false) bool isPlaying,

    /// Whether the metronome clicks are muted (beats keep running).
    @Default(false) bool isMuted,

    /// Whether a tempo save is in flight.
    @Default(false) bool isSaving,

    /// Patterns of the project, in order.
    @Default(<PatternResponse>[]) List<PatternResponse> patterns,

    /// The pattern being edited / looped.
    UuidValue? selectedPatternId,

    /// Whether a pattern change is in flight.
    @Default(false) bool isPatternBusy,

    /// Channels of the rack, in order.
    @Default(<ChannelResponse>[]) List<ChannelResponse> channels,

    /// Notes per pattern id (patterns are loaded on first selection).
    @Default(<UuidValue, List<StudioNote>>{})
    Map<UuidValue, List<StudioNote>> notes,

    /// Channel shown in the piano roll.
    UuidValue? selectedChannelId,

    /// What the workspace shows.
    @Default(StudioWorkspace.channelRack) StudioWorkspace workspace,

    /// Whether note edits are waiting to be saved or being saved.
    @Default(false) bool notesDirty,

    /// PAT (loop the pattern) or SONG (play the playlist).
    @Default(TransportMode.pattern) TransportMode mode,

    /// Clips of the playlist.
    @Default(<StudioClip>[]) List<StudioClip> clips,

    /// Audio files uploaded to the project.
    @Default(<SampleResponse>[]) List<SampleResponse> samples,

    /// Uploads in progress or failed (until dismissed).
    @Default(<SampleUpload>[]) List<SampleUpload> uploads,

    /// Whether playlist edits are waiting to be saved.
    @Default(false) bool playlistDirty,

    /// Error of the last save.
    Failure? failure,
  }) = _StudioState;

  const StudioState._();

  /// Whether the user may change the tempo (owner or write member).
  bool get canEdit =>
      project.access == ProjectAccess.owner ||
      project.access == ProjectAccess.write;

  /// Whether the tempo has unsaved changes.
  bool get isDirty => bpm != savedBpm;

  /// The selected pattern (falls back to the first one).
  PatternResponse? get selectedPattern {
    for (final p in patterns) {
      if (p.id == selectedPatternId) return p;
    }
    return patterns.isEmpty ? null : patterns.first;
  }

  /// Length of a pattern in bars (4 if unknown).
  int patternLength(UuidValue patternId) {
    for (final p in patterns) {
      if (p.id == patternId) return p.lengthBars;
    }
    return 4;
  }

  /// Length of a playlist clip in bars (pattern length or audio length).
  int clipLength(StudioClip clip) =>
      clip.isAudio ? (clip.lengthBars ?? 1) : patternLength(clip.patternId!);

  /// The uploaded sample [id], if known.
  SampleResponse? sampleById(UuidValue? id) {
    if (id == null) return null;
    for (final s in samples) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// End of the arrangement in bars (at least 1 bar).
  int get songBars {
    var end = 1;
    for (final c in clips) {
      final clipEnd = c.startBar + clipLength(c);
      if (clipEnd > end) end = clipEnd;
    }
    return end;
  }

  /// Loop length of the timeline and transport, in bars: the selected
  /// pattern (PAT) or the whole arrangement (SONG).
  int get loopBars => mode == TransportMode.song
      ? songBars
      : (selectedPattern?.lengthBars ?? 4);

  /// Steps (1/16) in the selected pattern (the channel rack / piano roll).
  int get patternSteps =>
      (selectedPattern?.lengthBars ?? 4) * ValidationRules.stepsPerBar;

  /// The clip covering [bar] on [track], if any.
  StudioClip? clipAt(int track, int bar) {
    for (final c in clips) {
      if (c.track == track &&
          bar >= c.startBar &&
          bar < c.startBar + clipLength(c)) {
        return c;
      }
    }
    return null;
  }

  /// Notes of the selected pattern (empty while loading).
  List<StudioNote> get currentNotes =>
      notes[selectedPattern?.id] ?? const <StudioNote>[];

  /// Whether the selected pattern's notes are loaded.
  bool get notesLoaded => notes.containsKey(selectedPattern?.id);

  /// The channel shown in the piano roll (falls back to the first one).
  ChannelResponse? get selectedChannel {
    for (final c in channels) {
      if (c.id == selectedChannelId) return c;
    }
    return channels.isEmpty ? null : channels.first;
  }
}
