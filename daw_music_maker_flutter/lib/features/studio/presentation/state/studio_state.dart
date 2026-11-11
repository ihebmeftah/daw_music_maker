import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'studio_state.freezed.dart';

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
}
