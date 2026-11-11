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

/// Input for changing a project's tempo (owner or write member).
abstract class UpdateProjectTempoRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UpdateProjectTempoRequest._({required this.bpm});

  factory UpdateProjectTempoRequest({required double bpm}) =
      _UpdateProjectTempoRequestImpl;

  factory UpdateProjectTempoRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdateProjectTempoRequest(
      bpm: (jsonSerialization['bpm'] as num).toDouble(),
    );
  }

  /// Tempo in beats per minute, 20–999; rounded to 2 decimals.
  double bpm;

  /// Returns a shallow copy of this [UpdateProjectTempoRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UpdateProjectTempoRequest copyWith({double? bpm});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateProjectTempoRequest',
      'bpm': bpm,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateProjectTempoRequest',
      'bpm': bpm,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UpdateProjectTempoRequestImpl extends UpdateProjectTempoRequest {
  _UpdateProjectTempoRequestImpl({required double bpm}) : super._(bpm: bpm);

  /// Returns a shallow copy of this [UpdateProjectTempoRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UpdateProjectTempoRequest copyWith({double? bpm}) {
    return UpdateProjectTempoRequest(bpm: bpm ?? this.bpm);
  }
}
