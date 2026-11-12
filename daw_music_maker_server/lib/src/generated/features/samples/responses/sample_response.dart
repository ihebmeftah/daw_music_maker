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
import 'package:daw_music_maker_server/src/generated/protocol.dart'
    as _iau3psze;
import 'package:serverpod/serverpod.dart' as _is;
import '../../../features/samples/enums/audio_format.dart' as _irh2gchs;

/// An uploaded sample as seen by the client.
abstract class SampleResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SampleResponse._({
    required this.id,
    required this.projectId,
    required this.name,
    required this.format,
    required this.sizeBytes,
    this.durationMs,
    this.peaks,
    required this.url,
    required this.createdAt,
  });

  factory SampleResponse({
    required _is.UuidValue id,
    required _is.UuidValue projectId,
    required String name,
    required _irh2gchs.AudioFormat format,
    required int sizeBytes,
    int? durationMs,
    List<double>? peaks,
    required String url,
    required DateTime createdAt,
  }) = _SampleResponseImpl;

  factory SampleResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return SampleResponse(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      format: _irh2gchs.AudioFormat.fromJson(
        (jsonSerialization['format'] as String),
      ),
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      durationMs: jsonSerialization['durationMs'] as int?,
      peaks: jsonSerialization['peaks'] == null
          ? null
          : _iau3psze.Protocol().deserialize<List<double>>(
              jsonSerialization['peaks'],
            ),
      url: jsonSerialization['url'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Sample id.
  _is.UuidValue id;

  /// The project.
  _is.UuidValue projectId;

  /// Display name.
  String name;

  /// File format.
  _irh2gchs.AudioFormat format;

  /// File size in bytes.
  int sizeBytes;

  /// Duration in milliseconds, if known.
  int? durationMs;

  /// Waveform outline (0–1), for WAV files.
  List<double>? peaks;

  /// Time-limited download URL (valid for 12 hours).
  String url;

  /// Upload time.
  DateTime createdAt;

  /// Returns a shallow copy of this [SampleResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SampleResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    int? durationMs,
    List<double>? peaks = const _is.$UndefinedList<double>(),
    String? url,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SampleResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'format': format.toJson(),
      'sizeBytes': sizeBytes,
      if (durationMs != null) 'durationMs': durationMs,
      if (peaks != null) 'peaks': peaks?.toJson(),
      'url': url,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SampleResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'format': format.toJson(),
      'sizeBytes': sizeBytes,
      if (durationMs != null) 'durationMs': durationMs,
      if (peaks != null) 'peaks': peaks?.toJson(),
      'url': url,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SampleResponseImpl extends SampleResponse {
  _SampleResponseImpl({
    required _is.UuidValue id,
    required _is.UuidValue projectId,
    required String name,
    required _irh2gchs.AudioFormat format,
    required int sizeBytes,
    int? durationMs,
    List<double>? peaks,
    required String url,
    required DateTime createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         format: format,
         sizeBytes: sizeBytes,
         durationMs: durationMs,
         peaks: peaks,
         url: url,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SampleResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SampleResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    Object? durationMs = _Undefined,
    List<double>? peaks = const _is.$UndefinedList<double>(),
    String? url,
    DateTime? createdAt,
  }) {
    return SampleResponse(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      peaks: peaks is _is.UndefinedSentinel
          ? this.peaks?.map((e0) => e0).toList()
          : peaks,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
