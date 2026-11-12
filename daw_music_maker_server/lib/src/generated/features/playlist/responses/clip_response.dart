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

/// A playlist clip as seen by the client.
abstract class ClipResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClipResponse._({
    required this.id,
    this.patternId,
    this.sampleId,
    this.lengthBars,
    required this.track,
    required this.startStep,
  });

  factory ClipResponse({
    required _is.UuidValue id,
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startStep,
  }) = _ClipResponseImpl;

  factory ClipResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClipResponse(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      patternId: jsonSerialization['patternId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['patternId']),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      lengthBars: jsonSerialization['lengthBars'] as int?,
      track: jsonSerialization['track'] as int,
      startStep: jsonSerialization['startStep'] as int,
    );
  }

  /// Clip id.
  _is.UuidValue id;

  /// The pattern it plays (pattern clips).
  _is.UuidValue? patternId;

  /// The sample it plays (audio clips).
  _is.UuidValue? sampleId;

  /// Length in bars (audio clips).
  int? lengthBars;

  /// Track (row).
  int track;

  /// Start in steps (1/16 notes) from the song start, 0–4095.
  int startStep;

  /// Returns a shallow copy of this [ClipResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ClipResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
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
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClipResponseImpl extends ClipResponse {
  _ClipResponseImpl({
    required _is.UuidValue id,
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
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
  @_is.useResult
  @override
  ClipResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    Object? lengthBars = _Undefined,
    int? track,
    int? startStep,
  }) {
    return ClipResponse(
      id: id ?? this.id,
      patternId: patternId is _is.UndefinedSentinel
          ? this.patternId
          : patternId,
      sampleId: sampleId is _is.UndefinedSentinel ? this.sampleId : sampleId,
      lengthBars: lengthBars is int? ? lengthBars : this.lengthBars,
      track: track ?? this.track,
      startStep: startStep ?? this.startStep,
    );
  }
}
