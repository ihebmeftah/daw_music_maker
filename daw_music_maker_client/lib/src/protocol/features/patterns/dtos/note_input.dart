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

/// One note in a [SavePatternNotesRequest].
abstract class NoteInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NoteInput._({
    required this.channelId,
    required this.tick,
    required this.lengthTicks,
    required this.pitch,
    required this.velocity,
  });

  factory NoteInput({
    required _isc.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) = _NoteInputImpl;

  factory NoteInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteInput(
      channelId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['channelId'],
      ),
      tick: jsonSerialization['tick'] as int,
      lengthTicks: jsonSerialization['lengthTicks'] as int,
      pitch: jsonSerialization['pitch'] as int,
      velocity: jsonSerialization['velocity'] as int,
    );
  }

  /// The channel (must belong to the pattern's project).
  _isc.UuidValue channelId;

  /// Start in ticks (0 ≤ tick < pattern length).
  int tick;

  /// Duration in ticks (≥ 1, ends within the pattern).
  int lengthTicks;

  /// MIDI pitch 0–127.
  int pitch;

  /// MIDI velocity 1–127.
  int velocity;

  /// Returns a shallow copy of this [NoteInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NoteInput copyWith({
    _isc.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteInput',
      'channelId': channelId.toJson(),
      'tick': tick,
      'lengthTicks': lengthTicks,
      'pitch': pitch,
      'velocity': velocity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NoteInput',
      'channelId': channelId.toJson(),
      'tick': tick,
      'lengthTicks': lengthTicks,
      'pitch': pitch,
      'velocity': velocity,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _NoteInputImpl extends NoteInput {
  _NoteInputImpl({
    required _isc.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) : super._(
         channelId: channelId,
         tick: tick,
         lengthTicks: lengthTicks,
         pitch: pitch,
         velocity: velocity,
       );

  /// Returns a shallow copy of this [NoteInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NoteInput copyWith({
    _isc.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  }) {
    return NoteInput(
      channelId: channelId ?? this.channelId,
      tick: tick ?? this.tick,
      lengthTicks: lengthTicks ?? this.lengthTicks,
      pitch: pitch ?? this.pitch,
      velocity: velocity ?? this.velocity,
    );
  }
}
