import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_clip.freezed.dart';

/// A clip on the playlist (song arrangement) while editing: a pattern clip
/// ([patternId]) or an audio clip ([sampleId] + [lengthBars]). The playlist
/// is saved as a whole list, so clips carry no server id.
@freezed
abstract class StudioClip with _$StudioClip {
  /// Creates a clip.
  const factory StudioClip({
    /// The pattern it plays (its length is the clip's length).
    UuidValue? patternId,

    /// The uploaded sample of an audio clip.
    UuidValue? sampleId,

    /// Length of an audio clip in bars.
    int? lengthBars,

    /// Playlist track (row), 0-based.
    required int track,

    /// Start in steps (1/16 notes) from the song start.
    required int startStep,
  }) = _StudioClip;

  const StudioClip._();

  /// Builds a clip from a server response.
  factory StudioClip.fromResponse(ClipResponse clip) => StudioClip(
    patternId: clip.patternId,
    sampleId: clip.sampleId,
    lengthBars: clip.lengthBars,
    track: clip.track,
    startStep: clip.startStep,
  );

  /// Whether this is an audio clip.
  bool get isAudio => sampleId != null;

  /// The request form sent to the server.
  ClipInput toInput() => ClipInput(
    patternId: patternId,
    sampleId: sampleId,
    lengthBars: lengthBars,
    track: track,
    startStep: startStep,
  );
}
