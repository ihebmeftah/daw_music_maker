import '../../../core/validation/validation_rules.dart';
import '../../../generated/protocol.dart';

/// Pure rules for the playlist (no database).
abstract final class PlaylistRules {
  /// Validates a complete playlist: known patterns, track and bar ranges,
  /// clips ending within the song limit and no overlaps on a track.
  ///
  /// [patternLengths] maps the project's pattern ids to their length in bars;
  /// [sampleIds] are the project's uploaded samples (audio clips).
  ///
  /// Throws [AppException] with [ErrorCode.validation] (`clips`) on the first
  /// problem, or [ErrorCode.limitReached] above the clip cap.
  static void validate(
    List<ClipInput> clips, {
    required Map<Object, int> patternLengths,
    Set<Object> sampleIds = const {},
  }) {
    if (clips.length > ValidationRules.playlistClipsMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A playlist can have at most ${ValidationRules.playlistClipsMax} '
            'clips',
      );
    }
    final byTrack = <int, List<(int, int)>>{};
    for (final (i, c) in clips.indexed) {
      final isAudio = c.sampleId != null;
      final length = isAudio ? c.lengthBars : patternLengths[c.patternId];
      String? error;
      if ((c.patternId == null) == (c.sampleId == null)) {
        error = 'needs exactly one pattern or sample';
      } else if (isAudio && !sampleIds.contains(c.sampleId)) {
        error = 'unknown sample';
      } else if (isAudio &&
          (length == null ||
              length < 1 ||
              length > ValidationRules.audioClipBarsMax)) {
        error = 'audio length must be 1–${ValidationRules.audioClipBarsMax} bars';
      } else if (length == null) {
        error = 'unknown pattern';
      } else if (c.track < 0 || c.track >= ValidationRules.playlistTracks) {
        error = 'track must be 1–${ValidationRules.playlistTracks}';
      } else if (c.startStep < 0 ||
          c.startStep + length * ValidationRules.stepsPerBar >
              ValidationRules.playlistBarsMax * ValidationRules.stepsPerBar) {
        error = 'must fit in ${ValidationRules.playlistBarsMax} bars';
      } else {
        // Spans in steps: clips may start on any step.
        final span = (
          c.startStep,
          c.startStep + length * ValidationRules.stepsPerBar,
        );
        final others = byTrack[c.track] ??= [];
        if (others.any((o) => span.$1 < o.$2 && o.$1 < span.$2)) {
          error = 'overlaps another clip on the track';
        } else {
          others.add(span);
        }
      }
      if (error != null) {
        throw AppException(
          code: ErrorCode.validation,
          fieldErrors: {'clips': 'Clip ${i + 1}: $error'},
        );
      }
    }
  }
}
