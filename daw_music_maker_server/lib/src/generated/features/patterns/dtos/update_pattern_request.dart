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

/// Full replacement of a pattern's settings (owner or write member).
abstract class UpdatePatternRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UpdatePatternRequest._({
    required this.name,
    required this.colorIndex,
    required this.lengthBars,
  });

  factory UpdatePatternRequest({
    required String name,
    required int colorIndex,
    required int lengthBars,
  }) = _UpdatePatternRequestImpl;

  factory UpdatePatternRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdatePatternRequest(
      name: jsonSerialization['name'] as String,
      colorIndex: jsonSerialization['colorIndex'] as int,
      lengthBars: jsonSerialization['lengthBars'] as int,
    );
  }

  /// Display name, 1–40 chars after trimming.
  String name;

  /// Color index (0–7).
  int colorIndex;

  /// Length in bars (1–16).
  int lengthBars;

  /// Returns a shallow copy of this [UpdatePatternRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UpdatePatternRequest copyWith({
    String? name,
    int? colorIndex,
    int? lengthBars,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdatePatternRequest',
      'name': name,
      'colorIndex': colorIndex,
      'lengthBars': lengthBars,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdatePatternRequest',
      'name': name,
      'colorIndex': colorIndex,
      'lengthBars': lengthBars,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UpdatePatternRequestImpl extends UpdatePatternRequest {
  _UpdatePatternRequestImpl({
    required String name,
    required int colorIndex,
    required int lengthBars,
  }) : super._(
         name: name,
         colorIndex: colorIndex,
         lengthBars: lengthBars,
       );

  /// Returns a shallow copy of this [UpdatePatternRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UpdatePatternRequest copyWith({
    String? name,
    int? colorIndex,
    int? lengthBars,
  }) {
    return UpdatePatternRequest(
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      lengthBars: lengthBars ?? this.lengthBars,
    );
  }
}
