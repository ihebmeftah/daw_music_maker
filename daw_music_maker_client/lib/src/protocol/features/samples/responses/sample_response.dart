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
import 'package:daw_music_maker_client/src/protocol/protocol.dart' as _i5v019zt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../../features/samples/enums/audio_format.dart' as _irh2gchs;

/// An uploaded sample as seen by the client.
abstract class SampleResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
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
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _isc.UuidValueJsonExtension.fromJson(
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
          : _i5v019zt.Protocol().deserialize<List<double>>(
              jsonSerialization['peaks'],
            ),
      url: jsonSerialization['url'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Sample id.
  _isc.UuidValue id;

  /// The project.
  _isc.UuidValue projectId;

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
  @_isc.useResult
  SampleResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    int? durationMs,
    List<double>? peaks = const _isc.$UndefinedList<double>(),
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SampleResponseImpl extends SampleResponse {
  _SampleResponseImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
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
  @_isc.useResult
  @override
  SampleResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    _irh2gchs.AudioFormat? format,
    int? sizeBytes,
    Object? durationMs = _Undefined,
    List<double>? peaks = const _isc.$UndefinedList<double>(),
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
      peaks: peaks is _isc.UndefinedSentinel
          ? this.peaks?.map((e0) => e0).toList()
          : peaks,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
