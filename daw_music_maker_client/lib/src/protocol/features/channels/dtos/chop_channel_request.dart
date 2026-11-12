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

/// Chops a channel's region into equal slices, one new channel each.
abstract class ChopChannelRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChopChannelRequest._({required this.slices});

  factory ChopChannelRequest({required int slices}) = _ChopChannelRequestImpl;

  factory ChopChannelRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChopChannelRequest(slices: jsonSerialization['slices'] as int);
  }

  /// Number of slices: 2, 4, 8 or 16.
  int slices;

  /// Returns a shallow copy of this [ChopChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChopChannelRequest copyWith({int? slices});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChopChannelRequest',
      'slices': slices,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChopChannelRequest',
      'slices': slices,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ChopChannelRequestImpl extends ChopChannelRequest {
  _ChopChannelRequestImpl({required int slices}) : super._(slices: slices);

  /// Returns a shallow copy of this [ChopChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChopChannelRequest copyWith({int? slices}) {
    return ChopChannelRequest(slices: slices ?? this.slices);
  }
}
