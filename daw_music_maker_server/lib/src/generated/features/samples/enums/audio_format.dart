/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Audio file formats accepted for uploads.
enum AudioFormat implements _is.SerializableModel {
  /// RIFF/WAVE (PCM or float) — gets a server-computed waveform and duration.
  wav,

  /// MPEG-1/2 Layer III.
  mp3,

  /// Ogg (Vorbis/Opus).
  ogg,

  /// Free Lossless Audio Codec.
  flac;

  static AudioFormat fromJson(String name) {
    switch (name) {
      case 'wav':
        return AudioFormat.wav;
      case 'mp3':
        return AudioFormat.mp3;
      case 'ogg':
        return AudioFormat.ogg;
      case 'flac':
        return AudioFormat.flac;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AudioFormat"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
