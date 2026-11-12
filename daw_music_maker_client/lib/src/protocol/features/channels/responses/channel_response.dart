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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../../features/channels/enums/sample_kind.dart' as _ixhlpt54;

/// A channel as seen by the client.
abstract class ChannelResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChannelResponse._({
    required this.id,
    required this.projectId,
    required this.name,
    this.sample,
    this.sampleId,
    required this.volume,
    required this.muted,
    required this.pan,
    required this.pitch,
    required this.startFrac,
    required this.endFrac,
    required this.position,
  });

  factory ChannelResponse({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String name,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId,
    required double volume,
    required bool muted,
    required double pan,
    required int pitch,
    required double startFrac,
    required double endFrac,
    required int position,
  }) = _ChannelResponseImpl;

  factory ChannelResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChannelResponse(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      sample: jsonSerialization['sample'] == null
          ? null
          : _ixhlpt54.SampleKind.fromJson(
              (jsonSerialization['sample'] as String),
            ),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      volume: (jsonSerialization['volume'] as num).toDouble(),
      muted: _isc.BoolJsonExtension.fromJson(jsonSerialization['muted']),
      pan: (jsonSerialization['pan'] as num).toDouble(),
      pitch: jsonSerialization['pitch'] as int,
      startFrac: (jsonSerialization['startFrac'] as num).toDouble(),
      endFrac: (jsonSerialization['endFrac'] as num).toDouble(),
      position: jsonSerialization['position'] as int,
    );
  }

  /// Channel id.
  _isc.UuidValue id;

  /// The project.
  _isc.UuidValue projectId;

  /// Display name.
  String name;

  /// The built-in sample this channel plays (null for uploaded samples).
  _ixhlpt54.SampleKind? sample;

  /// The uploaded sample this channel plays, if any.
  _isc.UuidValue? sampleId;

  /// Volume, 0.0–1.0.
  double volume;

  /// Whether the channel is silenced.
  bool muted;

  /// Stereo position, -1.0 – 1.0.
  double pan;

  /// Transposition in semitones.
  int pitch;

  /// Start of the played region (fraction).
  double startFrac;

  /// End of the played region (fraction).
  double endFrac;

  /// Order in the rack.
  int position;

  /// Returns a shallow copy of this [ChannelResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChannelResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    int? position,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChannelResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      if (sample != null) 'sample': sample?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      'volume': volume,
      'muted': muted,
      'pan': pan,
      'pitch': pitch,
      'startFrac': startFrac,
      'endFrac': endFrac,
      'position': position,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChannelResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      if (sample != null) 'sample': sample?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      'volume': volume,
      'muted': muted,
      'pan': pan,
      'pitch': pitch,
      'startFrac': startFrac,
      'endFrac': endFrac,
      'position': position,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelResponseImpl extends ChannelResponse {
  _ChannelResponseImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String name,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId,
    required double volume,
    required bool muted,
    required double pan,
    required int pitch,
    required double startFrac,
    required double endFrac,
    required int position,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         sample: sample,
         sampleId: sampleId,
         volume: volume,
         muted: muted,
         pan: pan,
         pitch: pitch,
         startFrac: startFrac,
         endFrac: endFrac,
         position: position,
       );

  /// Returns a shallow copy of this [ChannelResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChannelResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    Object? sample = _Undefined,
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
    int? position,
  }) {
    return ChannelResponse(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      sample: sample is _ixhlpt54.SampleKind? ? sample : this.sample,
      sampleId: sampleId is _isc.UndefinedSentinel ? this.sampleId : sampleId,
      volume: volume ?? this.volume,
      muted: muted ?? this.muted,
      pan: pan ?? this.pan,
      pitch: pitch ?? this.pitch,
      startFrac: startFrac ?? this.startFrac,
      endFrac: endFrac ?? this.endFrac,
      position: position ?? this.position,
    );
  }
}
