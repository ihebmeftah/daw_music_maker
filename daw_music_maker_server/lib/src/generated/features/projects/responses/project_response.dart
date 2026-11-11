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
import 'package:daw_music_maker_server/src/generated/protocol.dart'
    as _iau3psze;
import 'package:serverpod/serverpod.dart' as _is;
import '../../../features/projects/enums/project_access.dart' as _ij4p9moa;
import '../../../features/projects/enums/project_visibility.dart' as _iih43j5r;

/// A project as seen by the caller.
abstract class ProjectResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectResponse._({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.genres,
    required this.visibility,
    required this.allowContributions,
    required this.access,
    required this.memberCount,
    required this.hasPendingJoinRequest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectResponse({
    required _is.UuidValue id,
    required _is.UuidValue ownerId,
    required String name,
    required String description,
    required List<String> genres,
    required _iih43j5r.ProjectVisibility visibility,
    required bool allowContributions,
    required _ij4p9moa.ProjectAccess access,
    required int memberCount,
    required bool hasPendingJoinRequest,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectResponseImpl;

  factory ProjectResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectResponse(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      genres: _iau3psze.Protocol().deserialize<List<String>>(
        jsonSerialization['genres'],
      ),
      visibility: _iih43j5r.ProjectVisibility.fromJson(
        (jsonSerialization['visibility'] as String),
      ),
      allowContributions: _is.BoolJsonExtension.fromJson(
        jsonSerialization['allowContributions'],
      ),
      access: _ij4p9moa.ProjectAccess.fromJson(
        (jsonSerialization['access'] as String),
      ),
      memberCount: jsonSerialization['memberCount'] as int,
      hasPendingJoinRequest: _is.BoolJsonExtension.fromJson(
        jsonSerialization['hasPendingJoinRequest'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// Project id.
  _is.UuidValue id;

  /// Owner's user id.
  _is.UuidValue ownerId;

  /// Display name.
  String name;

  /// Description (may be empty).
  String description;

  /// Genre tags.
  List<String> genres;

  /// Who can see the project.
  _iih43j5r.ProjectVisibility visibility;

  /// Whether collaborators can be invited / request to join.
  bool allowContributions;

  /// The caller's relationship to the project.
  _ij4p9moa.ProjectAccess access;

  /// Number of members, excluding the owner.
  int memberCount;

  /// Whether the caller has a pending join request for this project.
  bool hasPendingJoinRequest;

  /// Creation time.
  DateTime createdAt;

  /// Last modification time.
  DateTime updatedAt;

  /// Returns a shallow copy of this [ProjectResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    _ij4p9moa.ProjectAccess? access,
    int? memberCount,
    bool? hasPendingJoinRequest,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectResponse',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      'description': description,
      'genres': genres.toJson(),
      'visibility': visibility.toJson(),
      'allowContributions': allowContributions,
      'access': access.toJson(),
      'memberCount': memberCount,
      'hasPendingJoinRequest': hasPendingJoinRequest,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectResponse',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      'description': description,
      'genres': genres.toJson(),
      'visibility': visibility.toJson(),
      'allowContributions': allowContributions,
      'access': access.toJson(),
      'memberCount': memberCount,
      'hasPendingJoinRequest': hasPendingJoinRequest,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProjectResponseImpl extends ProjectResponse {
  _ProjectResponseImpl({
    required _is.UuidValue id,
    required _is.UuidValue ownerId,
    required String name,
    required String description,
    required List<String> genres,
    required _iih43j5r.ProjectVisibility visibility,
    required bool allowContributions,
    required _ij4p9moa.ProjectAccess access,
    required int memberCount,
    required bool hasPendingJoinRequest,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         name: name,
         description: description,
         genres: genres,
         visibility: visibility,
         allowContributions: allowContributions,
         access: access,
         memberCount: memberCount,
         hasPendingJoinRequest: hasPendingJoinRequest,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProjectResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
    _ij4p9moa.ProjectAccess? access,
    int? memberCount,
    bool? hasPendingJoinRequest,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectResponse(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      genres: genres ?? this.genres.map((e0) => e0).toList(),
      visibility: visibility ?? this.visibility,
      allowContributions: allowContributions ?? this.allowContributions,
      access: access ?? this.access,
      memberCount: memberCount ?? this.memberCount,
      hasPendingJoinRequest:
          hasPendingJoinRequest ?? this.hasPendingJoinRequest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
