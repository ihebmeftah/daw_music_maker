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

/// A pattern as seen by the client.
abstract class PatternResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PatternResponse._({
    required this.id,
    required this.projectId,
    required this.name,
    required this.colorIndex,
    required this.lengthBars,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatternResponse({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String name,
    required int colorIndex,
    required int lengthBars,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PatternResponseImpl;

  factory PatternResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatternResponse(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      name: jsonSerialization['name'] as String,
      colorIndex: jsonSerialization['colorIndex'] as int,
      lengthBars: jsonSerialization['lengthBars'] as int,
      position: jsonSerialization['position'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// Pattern id.
  _isc.UuidValue id;

  /// The project.
  _isc.UuidValue projectId;

  /// Display name.
  String name;

  /// Index into the track color palette (0–7).
  int colorIndex;

  /// Loop length in bars.
  int lengthBars;

  /// Sort order within the project.
  int position;

  /// Creation time.
  DateTime createdAt;

  /// Last modification time.
  DateTime updatedAt;

  /// Returns a shallow copy of this [PatternResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PatternResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatternResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'colorIndex': colorIndex,
      'lengthBars': lengthBars,
      'position': position,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatternResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'name': name,
      'colorIndex': colorIndex,
      'lengthBars': lengthBars,
      'position': position,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PatternResponseImpl extends PatternResponse {
  _PatternResponseImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String name,
    required int colorIndex,
    required int lengthBars,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         colorIndex: colorIndex,
         lengthBars: lengthBars,
         position: position,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PatternResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PatternResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? name,
    int? colorIndex,
    int? lengthBars,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatternResponse(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      lengthBars: lengthBars ?? this.lengthBars,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
