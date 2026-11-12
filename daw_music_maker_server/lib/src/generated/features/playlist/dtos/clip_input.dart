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

/// One clip in a [SavePlaylistRequest]: exactly one of [patternId] and
/// [sampleId].
abstract class ClipInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClipInput._({
    this.patternId,
    this.sampleId,
    this.lengthBars,
    required this.track,
    required this.startBar,
  });

  factory ClipInput({
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startBar,
  }) = _ClipInputImpl;

  factory ClipInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClipInput(
      patternId: jsonSerialization['patternId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['patternId']),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      lengthBars: jsonSerialization['lengthBars'] as int?,
      track: jsonSerialization['track'] as int,
      startBar: jsonSerialization['startBar'] as int,
    );
  }

  /// The pattern (must belong to the project).
  _is.UuidValue? patternId;

  /// The uploaded sample of an audio clip (must belong to the project).
  _is.UuidValue? sampleId;

  /// Length of an audio clip in bars (1–64).
  int? lengthBars;

  /// Track (row), 0–15.
  int track;

  /// First bar, 0–255.
  int startBar;

  /// Returns a shallow copy of this [ClipInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ClipInput copyWith({
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    int? lengthBars,
    int? track,
    int? startBar,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClipInput',
      if (patternId != null) 'patternId': patternId?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (lengthBars != null) 'lengthBars': lengthBars,
      'track': track,
      'startBar': startBar,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClipInput',
      if (patternId != null) 'patternId': patternId?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (lengthBars != null) 'lengthBars': lengthBars,
      'track': track,
      'startBar': startBar,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClipInputImpl extends ClipInput {
  _ClipInputImpl({
    _is.UuidValue? patternId,
    _is.UuidValue? sampleId,
    int? lengthBars,
    required int track,
    required int startBar,
  }) : super._(
         patternId: patternId,
         sampleId: sampleId,
         lengthBars: lengthBars,
         track: track,
         startBar: startBar,
       );

  /// Returns a shallow copy of this [ClipInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ClipInput copyWith({
    _is.UuidValue? patternId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? sampleId = const _is.$UndefinedUuidValue(),
    Object? lengthBars = _Undefined,
    int? track,
    int? startBar,
  }) {
    return ClipInput(
      patternId: patternId is _is.UndefinedSentinel
          ? this.patternId
          : patternId,
      sampleId: sampleId is _is.UndefinedSentinel ? this.sampleId : sampleId,
      lengthBars: lengthBars is int? ? lengthBars : this.lengthBars,
      track: track ?? this.track,
      startBar: startBar ?? this.startBar,
    );
  }
}
