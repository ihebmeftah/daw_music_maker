import 'dart:typed_data';

import 'package:daw_music_maker_client/daw_music_maker_client.dart';

import 'studio_clip.dart';
import 'studio_note.dart';

/// Data the studio needs: the project and its tempo.
///
/// Every method throws a `Failure` (see `core/errors/failure.dart`) on error.
abstract interface class StudioRepository {
  /// Loads the project opened in the studio.
  Future<ProjectResponse> loadProject(UuidValue projectId);

  /// Saves the project's tempo (owner or write member).
  Future<ProjectResponse> saveTempo(UuidValue projectId, double bpm);

  /// Patterns of the project, in order.
  Future<List<PatternResponse>> listPatterns(UuidValue projectId);

  /// Adds a pattern with server defaults ("Pattern N", next color, 4 bars).
  Future<PatternResponse> createPattern(UuidValue projectId);

  /// Saves a pattern's name, color and length.
  Future<PatternResponse> updatePattern(
    UuidValue patternId, {
    required String name,
    required int colorIndex,
    required int lengthBars,
  });

  /// Duplicates a pattern.
  Future<PatternResponse> clonePattern(UuidValue patternId);

  /// Deletes a pattern (never the last one).
  Future<void> deletePattern(UuidValue patternId);

  /// Channels of the project, in rack order.
  Future<List<ChannelResponse>> listChannels(UuidValue projectId);

  /// Adds a channel playing a built-in [sample] or an uploaded [sampleId].
  Future<ChannelResponse> createChannel(
    UuidValue projectId, {
    SampleKind? sample,
    UuidValue? sampleId,
  });

  /// Saves a channel's settings (incl. sampler: pan, pitch, region).
  Future<ChannelResponse> updateChannel(
    UuidValue channelId, {
    required String name,
    required double volume,
    required bool muted,
    double pan = 0,
    int pitch = 0,
    double startFrac = 0,
    double endFrac = 1,
  });

  /// Chops a channel's region into [slices] new channels.
  Future<List<ChannelResponse>> chopChannel(UuidValue channelId, int slices);

  /// Samples uploaded to the project.
  Future<List<SampleResponse>> listSamples(UuidValue projectId);

  /// Uploads an audio file (≤ 10 MB) and registers it; [onProgress]
  /// receives 0–1 while bytes are sent.
  Future<SampleResponse> uploadSample(
    UuidValue projectId, {
    required String fileName,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
  });

  /// Deletes an uploaded sample (and the channels / clips using it).
  Future<void> deleteSample(UuidValue sampleId);

  /// Deletes a channel and its notes.
  Future<void> deleteChannel(UuidValue channelId);

  /// Clips of the project's playlist.
  Future<List<StudioClip>> listClips(UuidValue projectId);

  /// Replaces the project's playlist; returns the clips as saved.
  Future<List<StudioClip>> saveClips(
    UuidValue projectId,
    List<StudioClip> clips,
  );

  /// Notes of a pattern.
  Future<List<StudioNote>> listNotes(UuidValue patternId);

  /// Replaces all notes of a pattern; returns them as saved.
  Future<List<StudioNote>> saveNotes(
    UuidValue patternId,
    List<StudioNote> notes,
  );
}
