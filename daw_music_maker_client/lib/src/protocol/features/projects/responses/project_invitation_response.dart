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

/// A pending invitation, as seen by the project owner or by the invitee.
abstract class ProjectInvitationResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectInvitationResponse._({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory ProjectInvitationResponse({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String projectName,
    required String email,
    required _ix943hb1.ProjectRole role,
    required DateTime createdAt,
  }) = _ProjectInvitationResponseImpl;

  factory ProjectInvitationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectInvitationResponse(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      projectName: jsonSerialization['projectName'] as String,
      email: jsonSerialization['email'] as String,
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// Invitation id.
  _isc.UuidValue id;

  /// The project.
  _isc.UuidValue projectId;

  /// The project's name.
  String projectName;

  /// Invitee email.
  String email;

  /// Role granted on acceptance.
  _ix943hb1.ProjectRole role;

  /// When it was sent.
  DateTime createdAt;

  /// Returns a shallow copy of this [ProjectInvitationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectInvitationResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? projectName,
    String? email,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectInvitationResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'projectName': projectName,
      'email': email,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectInvitationResponse',
      'id': id.toJson(),
      'projectId': projectId.toJson(),
      'projectName': projectName,
      'email': email,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProjectInvitationResponseImpl extends ProjectInvitationResponse {
  _ProjectInvitationResponseImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue projectId,
    required String projectName,
    required String email,
    required _ix943hb1.ProjectRole role,
    required DateTime createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         projectName: projectName,
         email: email,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ProjectInvitationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectInvitationResponse copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? projectId,
    String? projectName,
    String? email,
    _ix943hb1.ProjectRole? role,
    DateTime? createdAt,
  }) {
    return ProjectInvitationResponse(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
