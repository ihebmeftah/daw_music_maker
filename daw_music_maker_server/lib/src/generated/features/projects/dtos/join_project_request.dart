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

/// Input for asking to join a public project that accepts contributions.
abstract class JoinProjectRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JoinProjectRequest._({
    required this.projectId,
    required this.role,
  });

  factory JoinProjectRequest({
    required _is.UuidValue projectId,
    required _ix943hb1.ProjectRole role,
  }) = _JoinProjectRequestImpl;

  factory JoinProjectRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinProjectRequest(
      projectId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      role: _ix943hb1.ProjectRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  /// The project to join.
  _is.UuidValue projectId;

  /// Role the caller asks for.
  _ix943hb1.ProjectRole role;

  /// Returns a shallow copy of this [JoinProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JoinProjectRequest copyWith({
    _is.UuidValue? projectId,
    _ix943hb1.ProjectRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinProjectRequest',
      'projectId': projectId.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinProjectRequest',
      'projectId': projectId.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _JoinProjectRequestImpl extends JoinProjectRequest {
  _JoinProjectRequestImpl({
    required _is.UuidValue projectId,
    required _ix943hb1.ProjectRole role,
  }) : super._(
         projectId: projectId,
         role: role,
       );

  /// Returns a shallow copy of this [JoinProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JoinProjectRequest copyWith({
    _is.UuidValue? projectId,
    _ix943hb1.ProjectRole? role,
  }) {
    return JoinProjectRequest(
      projectId: projectId ?? this.projectId,
      role: role ?? this.role,
    );
  }
}
