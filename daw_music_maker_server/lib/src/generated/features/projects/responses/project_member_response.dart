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

/// A person with access to a project (the owner is included, first).
///
/// Emails are only returned to the project's owner and members.
abstract class ProjectMemberResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectMemberResponse._({
    required this.userId,
    this.email,
    required this.role,
    required this.isOwner,
    required this.joinedAt,
  });

  factory ProjectMemberResponse({
    required _is.UuidValue userId,
    String? email,
    required _ix943hb1.ProjectRole role,
    required bool isOwner,
    required DateTime joinedAt,
  }) = _ProjectMemberResponseImpl;

  factory ProjectMemberResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectMemberResponse(
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String?,
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      isOwner: _is.BoolJsonExtension.fromJson(jsonSerialization['isOwner']),
      joinedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
    );
  }

  /// The person's user id.
  _is.UuidValue userId;

  /// Their email address, if they have an email account.
  String? email;

  /// Their role (the owner is reported as write).
  _ix943hb1.ProjectRole role;

  /// Whether this person owns the project.
  bool isOwner;

  /// When they joined (the project's creation time for the owner).
  DateTime joinedAt;

  /// Returns a shallow copy of this [ProjectMemberResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectMemberResponse copyWith({
    _is.UuidValue? userId,
    String? email,
    _ix943hb1.ProjectRole? role,
    bool? isOwner,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectMemberResponse',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'isOwner': isOwner,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectMemberResponse',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'isOwner': isOwner,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectMemberResponseImpl extends ProjectMemberResponse {
  _ProjectMemberResponseImpl({
    required _is.UuidValue userId,
    String? email,
    required _ix943hb1.ProjectRole role,
    required bool isOwner,
    required DateTime joinedAt,
  }) : super._(
         userId: userId,
         email: email,
         role: role,
         isOwner: isOwner,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [ProjectMemberResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectMemberResponse copyWith({
    _is.UuidValue? userId,
    Object? email = _Undefined,
    _ix943hb1.ProjectRole? role,
    bool? isOwner,
    DateTime? joinedAt,
  }) {
    return ProjectMemberResponse(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      isOwner: isOwner ?? this.isOwner,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
