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

/// Input for adding a pattern to a project (owner or write member).
abstract class CreatePatternRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CreatePatternRequest._({
    required this.projectId,
    this.name,
    this.colorIndex,
    this.lengthBars,
  });

  factory CreatePatternRequest({
    required _isc.UuidValue projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
  }) = _CreatePatternRequestImpl;

  factory CreatePatternRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CreatePatternRequest(
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String?,
      colorIndex: jsonSerialization['colorIndex'] as int?,
      lengthBars: jsonSerialization['lengthBars'] as int?,
    );
  }

  /// The project.
  _isc.UuidValue projectId;

  /// Optional name (1–40 chars); defaults to "Pattern N".
  String? name;

  /// Optional color index (0–7); defaults to the next color in the palette.
  int? colorIndex;

  /// Optional length in bars (1–16); defaults to 4.
  int? lengthBars;

  /// Returns a shallow copy of this [CreatePatternRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CreatePatternRequest copyWith({
    _isc.UuidValue? projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreatePatternRequest',
      'projectId': projectId.toJson(),
      if (name != null) 'name': name,
      if (colorIndex != null) 'colorIndex': colorIndex,
      if (lengthBars != null) 'lengthBars': lengthBars,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreatePatternRequest',
      'projectId': projectId.toJson(),
      if (name != null) 'name': name,
      if (colorIndex != null) 'colorIndex': colorIndex,
      if (lengthBars != null) 'lengthBars': lengthBars,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreatePatternRequestImpl extends CreatePatternRequest {
  _CreatePatternRequestImpl({
    required _isc.UuidValue projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
  }) : super._(
         projectId: projectId,
         name: name,
         colorIndex: colorIndex,
         lengthBars: lengthBars,
       );

  /// Returns a shallow copy of this [CreatePatternRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CreatePatternRequest copyWith({
    _isc.UuidValue? projectId,
    Object? name = _Undefined,
    Object? colorIndex = _Undefined,
    Object? lengthBars = _Undefined,
  }) {
    return CreatePatternRequest(
      projectId: projectId ?? this.projectId,
      name: name is String? ? name : this.name,
      colorIndex: colorIndex is int? ? colorIndex : this.colorIndex,
      lengthBars: lengthBars is int? ? lengthBars : this.lengthBars,
    );
  }
}
