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
import '../../../features/projects/enums/project_role.dart' as _ix943hb1;

/// Input for inviting someone to a project by email (owner only).
abstract class InviteMemberRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InviteMemberRequest._({
    required this.projectId,
    required this.email,
    required this.role,
  });

  factory InviteMemberRequest({
    required _isc.UuidValue projectId,
    required String email,
    required _ix943hb1.ProjectRole role,
  }) = _InviteMemberRequestImpl;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return InviteMemberRequest(
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      email: jsonSerialization['email'] as String,
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  /// The project to invite to.
  _isc.UuidValue projectId;

  /// Invitee email address.
  String email;

  /// Role granted on acceptance.
  _ix943hb1.ProjectRole role;

  /// Returns a shallow copy of this [InviteMemberRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InviteMemberRequest copyWith({
    _isc.UuidValue? projectId,
    String? email,
    _ix943hb1.ProjectRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InviteMemberRequest',
      'projectId': projectId.toJson(),
      'email': email,
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InviteMemberRequest',
      'projectId': projectId.toJson(),
      'email': email,
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _InviteMemberRequestImpl extends InviteMemberRequest {
  _InviteMemberRequestImpl({
    required _isc.UuidValue projectId,
    required String email,
    required _ix943hb1.ProjectRole role,
  }) : super._(
         projectId: projectId,
         email: email,
         role: role,
       );

  /// Returns a shallow copy of this [InviteMemberRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InviteMemberRequest copyWith({
    _isc.UuidValue? projectId,
    String? email,
    _ix943hb1.ProjectRole? role,
  }) {
    return InviteMemberRequest(
      projectId: projectId ?? this.projectId,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}
