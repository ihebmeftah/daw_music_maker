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

/// A playlist clip as seen by the client.
abstract class ClipResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ClipResponse._({
    required this.id,
    this.patternId,
    this.sampleId,
    this.lengthBars,
    required this.track,
    required this.startStep,
  });

  factory ClipResponse({
    required _isc.UuidValue id,
    _isc.UuidValue? patternId,
    _isc.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startStep,
  }) = _ClipResponseImpl;

  factory ClipResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClipResponse(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      patternId: jsonSerialization['patternId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['patternId'],
            ),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      lengthBars: jsonSerialization['lengthBars'] as int?,
      track: jsonSerialization['track'] as int,
      startStep: jsonSerialization['startStep'] as int,
    );
  }

  /// Clip id.
  _isc.UuidValue id;

  /// The pattern it plays (pattern clips).
  _isc.UuidValue? patternId;

  /// The sample it plays (audio clips).
  _isc.UuidValue? sampleId;

  /// Length in bars (audio clips).
  int? lengthBars;

  /// Track (row).
  int track;

  /// Start in steps (1/16 notes) from the song start, 0–4095.
  int startStep;

  /// Returns a shallow copy of this [ClipResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ClipResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? patternId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    int? lengthBars,
    int? track,
    int? startStep,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClipResponse',
      'id': id.toJson(),
      if (patternId != null) 'patternId': patternId?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (lengthBars != null) 'lengthBars': lengthBars,
      'track': track,
      'startStep': startStep,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClipResponse',
      'id': id.toJson(),
      if (patternId != null) 'patternId': patternId?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (lengthBars != null) 'lengthBars': lengthBars,
      'track': track,
      'startStep': startStep,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClipResponseImpl extends ClipResponse {
  _ClipResponseImpl({
    required _isc.UuidValue id,
    _isc.UuidValue? patternId,
    _isc.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startStep,
  }) : super._(
         id: id,
         patternId: patternId,
         sampleId: sampleId,
         lengthBars: lengthBars,
         track: track,
         startStep: startStep,
       );

  /// Returns a shallow copy of this [ClipResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ClipResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? patternId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    Object? lengthBars = _Undefined,
    int? track,
    int? startStep,
  }) {
    return ClipResponse(
      id: id ?? this.id,
      patternId: patternId is _isc.UndefinedSentinel
          ? this.patternId
          : patternId,
      sampleId: sampleId is _isc.UndefinedSentinel ? this.sampleId : sampleId,
      lengthBars: lengthBars is int? ? lengthBars : this.lengthBars,
      track: track ?? this.track,
      startStep: startStep ?? this.startStep,
    );
  }
}
