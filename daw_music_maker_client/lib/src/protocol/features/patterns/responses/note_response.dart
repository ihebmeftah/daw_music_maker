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

/// A pattern note as seen by the client.
abstract class NoteResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NoteResponse._({
    required this.id,
    required this.channelId,
    required this.tick,
    required this.lengthTicks,
    required this.pitch,
    required this.velocity,
  });

  factory NoteResponse({
    required _isc.UuidValue id,
    required _isc.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) = _NoteResponseImpl;

  factory NoteResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteResponse(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      channelId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['channelId'],
      ),
      tick: jsonSerialization['tick'] as int,
      lengthTicks: jsonSerialization['lengthTicks'] as int,
      pitch: jsonSerialization['pitch'] as int,
      velocity: jsonSerialization['velocity'] as int,
    );
  }

  /// Note id.
  _isc.UuidValue id;

  /// The channel that plays it.
  _isc.UuidValue channelId;

  /// Start in ticks.
  int tick;

  /// Duration in ticks.
  int lengthTicks;

  /// MIDI pitch.
  int pitch;

  /// MIDI velocity.
  int velocity;

  /// Returns a shallow copy of this [NoteResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NoteResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteResponse',
      'id': id.toJson(),
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
      '__className__': 'NoteResponse',
      'id': id.toJson(),
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

class _NoteResponseImpl extends NoteResponse {
  _NoteResponseImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue channelId,
    required int tick,
    required int lengthTicks,
    required int pitch,
    required int velocity,
  }) : super._(
         id: id,
         channelId: channelId,
         tick: tick,
         lengthTicks: lengthTicks,
         pitch: pitch,
         velocity: velocity,
       );

  /// Returns a shallow copy of this [NoteResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NoteResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? channelId,
    int? tick,
    int? lengthTicks,
    int? pitch,
    int? velocity,
  }) {
    return NoteResponse(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      tick: tick ?? this.tick,
      lengthTicks: lengthTicks ?? this.lengthTicks,
      pitch: pitch ?? this.pitch,
      velocity: velocity ?? this.velocity,
    );
  }
}
