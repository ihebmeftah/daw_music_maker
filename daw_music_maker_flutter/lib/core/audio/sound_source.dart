import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// What a channel or clip plays: a bundled drum sample or an uploaded file.
sealed class SoundSource {
  const SoundSource();

  /// Stable cache key of the source (one player pool per key).
  String get key;
}

/// A sample bundled with the app (kick, snare, hats).
final class BuiltinSound extends SoundSource {
  /// Creates the source for [kind].
  const BuiltinSound(this.kind);

  /// The bundled sample.
  final SampleKind kind;

  @override
  String get key => 'builtin:${kind.name}';

  @override
  bool operator ==(Object other) => other is BuiltinSound && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;
}

/// An audio file uploaded to the project, fetched from [url].
final class UploadedSound extends SoundSource {
  /// Creates the source for the uploaded sample [sampleId].
  const UploadedSound(this.sampleId, this.url);

  /// The uploaded sample.
  final UuidValue sampleId;

  /// Download URL (time-limited).
  final String url;

  @override
  String get key => 'sample:$sampleId';

  @override
  bool operator ==(Object other) =>
      other is UploadedSound && other.sampleId == sampleId;

  @override
  int get hashCode => sampleId.hashCode;
}
