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
import '../../../features/projects/enums/project_role.dart' as _ix943hb1;

/// A pending join request, as seen by the project owner or by the requester.
abstract class JoinRequestResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JoinRequestResponse._({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.userId,
    this.email,
    required this.role,
    required this.createdAt,
  });

  factory JoinRequestResponse({
    required _is.UuidValue id,
    required _is.UuidValue projectId,
    required String projectName,
    required _is.UuidValue userId,
    String? email,
    required _ix943hb1.ProjectRole role,
    required DateTime createdAt,
  }) = _JoinRequestResponseImpl;

  factory JoinRequestResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinRequestResponse(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      projectName: jsonSerialization['projectName'] as String,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String?,
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Request id.
  _is.UuidValue id;

  /// The project.
  _is.UuidValue projectId;

  /// The project's name.
  String projectName;

  /// The requesting user.
  _is.UuidValue userId;

  /// The requester's email (shared with the owner by requesting).
  String? email;

  /// Role asked for.
  _ix943hb1.ProjectRole role;

  /// When it was sent.
  DateTime createdAt;

  /// Returns a shallow copy of this [JoinRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JoinRequestResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? projectId,
    String? projectName,
    _is.UuidValue? userId,
    String? email,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinRequestResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'projectName': projectName,
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinRequestResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'projectName': projectName,
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JoinRequestResponseImpl extends JoinRequestResponse {
  _JoinRequestResponseImpl({
    required _is.UuidValue id,
    required _is.UuidValue projectId,
    required String projectName,
    required _is.UuidValue userId,
    String? email,
    required _ix943hb1.ProjectRole role,
    required DateTime createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         projectName: projectName,
         userId: userId,
         email: email,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [JoinRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JoinRequestResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? projectId,
    String? projectName,
    _is.UuidValue? userId,
    Object? email = _Undefined,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
  }) {
    return JoinRequestResponse(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
