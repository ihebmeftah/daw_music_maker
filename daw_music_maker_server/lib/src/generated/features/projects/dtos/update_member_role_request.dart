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

/// Input for changing a member's role (owner only).
abstract class UpdateMemberRoleRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UpdateMemberRoleRequest._({
    required this.projectId,
    required this.userId,
    required this.role,
  });

  factory UpdateMemberRoleRequest({
    required _is.UuidValue projectId,
    required _is.UuidValue userId,
    required _ix943hb1.ProjectRole role,
  }) = _UpdateMemberRoleRequestImpl;

  factory UpdateMemberRoleRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdateMemberRoleRequest(
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  /// The project.
  _is.UuidValue projectId;

  /// The member's user id.
  _is.UuidValue userId;

  /// The new role.
  _ix943hb1.ProjectRole role;

  /// Returns a shallow copy of this [UpdateMemberRoleRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UpdateMemberRoleRequest copyWith({
    _is.UuidValue? projectId,
    _is.UuidValue? userId,
    _ix943hb1.ProjectRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateMemberRoleRequest',
      'projectId': projectId.toJson(),
      'userId': userId.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateMemberRoleRequest',
      'projectId': projectId.toJson(),
      'userId': userId.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UpdateMemberRoleRequestImpl extends UpdateMemberRoleRequest {
  _UpdateMemberRoleRequestImpl({
    required _is.UuidValue projectId,
    required _is.UuidValue userId,
    required _ix943hb1.ProjectRole role,
  }) : super._(
         projectId: projectId,
         userId: userId,
         role: role,
       );

  /// Returns a shallow copy of this [UpdateMemberRoleRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UpdateMemberRoleRequest copyWith({
    _is.UuidValue? projectId,
    _is.UuidValue? userId,
    _ix943hb1.ProjectRole? role,
  }) {
    return UpdateMemberRoleRequest(
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }
}
