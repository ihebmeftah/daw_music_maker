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

/// Full replacement of a channel's settings (owner or write member).
abstract class UpdateChannelRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UpdateChannelRequest._({
    required this.name,
    required this.volume,
    required this.muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  }) : pan = pan ?? 0.0,
       pitch = pitch ?? 0,
       startFrac = startFrac ?? 0.0,
       endFrac = endFrac ?? 1.0;

  factory UpdateChannelRequest({
    required String name,
    required double volume,
    required bool muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  }) = _UpdateChannelRequestImpl;

  factory UpdateChannelRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdateChannelRequest(
      name: jsonSerialization['name'] as String,
      volume: (jsonSerialization['volume'] as num).toDouble(),
      muted: _is.BoolJsonExtension.fromJson(jsonSerialization['muted']),
      pan: (jsonSerialization['pan'] as num?)?.toDouble(),
      pitch: jsonSerialization['pitch'] as int?,
      startFrac: (jsonSerialization['startFrac'] as num?)?.toDouble(),
      endFrac: (jsonSerialization['endFrac'] as num?)?.toDouble(),
    );
  }

  /// Display name, 1–40 chars after trimming.
  String name;

  /// Volume, 0.0–1.0.
  double volume;

  /// Whether the channel is silenced.
  bool muted;

  /// Stereo position, -1.0 – 1.0.
  double pan;

  /// Transposition in semitones, -24 – 24.
  int pitch;

  /// Start of the played region (0.0 ≤ start < end).
  double startFrac;

  /// End of the played region (start < end ≤ 1.0).
  double endFrac;

  /// Returns a shallow copy of this [UpdateChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UpdateChannelRequest copyWith({
    String? name,
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateChannelRequest',
      'name': name,
      'volume': volume,
      'muted': muted,
      'pan': pan,
      'pitch': pitch,
      'startFrac': startFrac,
      'endFrac': endFrac,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateChannelRequest',
      'name': name,
      'volume': volume,
      'muted': muted,
      'pan': pan,
      'pitch': pitch,
      'startFrac': startFrac,
      'endFrac': endFrac,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UpdateChannelRequestImpl extends UpdateChannelRequest {
  _UpdateChannelRequestImpl({
    required String name,
    required double volume,
    required bool muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  }) : super._(
         name: name,
         volume: volume,
         muted: muted,
         pan: pan,
         pitch: pitch,
         startFrac: startFrac,
         endFrac: endFrac,
       );

  /// Returns a shallow copy of this [UpdateChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UpdateChannelRequest copyWith({
    String? name,
    double? volume,
    bool? muted,
    double? pan,
    int? pitch,
    double? startFrac,
    double? endFrac,
  }) {
    return UpdateChannelRequest(
      name: name ?? this.name,
      volume: volume ?? this.volume,
      muted: muted ?? this.muted,
      pan: pan ?? this.pan,
      pitch: pitch ?? this.pitch,
      startFrac: startFrac ?? this.startFrac,
      endFrac: endFrac ?? this.endFrac,
    );
  }
}
