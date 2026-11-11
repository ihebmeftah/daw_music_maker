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
import 'package:daw_music_maker_client/src/protocol/protocol.dart' as _i5v019zt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../../features/projects/enums/project_visibility.dart' as _iih43j5r;

/// Full replacement of a project's details. Validated like
/// [CreateProjectRequest]. Members with write permission may change name,
/// description and genres; only the owner may change visibility and
/// contributions.
abstract class UpdateProjectRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UpdateProjectRequest._({
    required this.name,
    required this.description,
    required this.genres,
    required this.visibility,
    required this.allowContributions,
  });

  factory UpdateProjectRequest({
    required String name,
    required String description,
    required List<String> genres,
    required _iih43j5r.ProjectVisibility visibility,
    required bool allowContributions,
  }) = _UpdateProjectRequestImpl;

  factory UpdateProjectRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdateProjectRequest(
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      genres: _i5v019zt.Protocol().deserialize<List<String>>(
        jsonSerialization['genres'],
      ),
      visibility: _iih43j5r.ProjectVisibility.fromJson(
        (jsonSerialization['visibility'] as String),
      ),
      allowContributions: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['allowContributions'],
      ),
    );
  }

  /// Display name, 1–80 chars after trimming.
  String name;

  /// Description, up to 1000 chars after trimming.
  String description;

  /// Genre tags: max 8, each 1–24 chars; duplicates are removed.
  List<String> genres;

  /// Who can see the project (owner only).
  _iih43j5r.ProjectVisibility visibility;

  /// Whether collaborators can be invited / request to join (owner only).
  bool allowContributions;

  /// Returns a shallow copy of this [UpdateProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UpdateProjectRequest copyWith({
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateProjectRequest',
      'name': name,
      'description': description,
      'genres': genres.toJson(),
      'visibility': visibility.toJson(),
      'allowContributions': allowContributions,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateProjectRequest',
      'name': name,
      'description': description,
      'genres': genres.toJson(),
      'visibility': visibility.toJson(),
      'allowContributions': allowContributions,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UpdateProjectRequestImpl extends UpdateProjectRequest {
  _UpdateProjectRequestImpl({
    required String name,
    required String description,
    required List<String> genres,
    required _iih43j5r.ProjectVisibility visibility,
    required bool allowContributions,
  }) : super._(
         name: name,
         description: description,
         genres: genres,
         visibility: visibility,
         allowContributions: allowContributions,
       );

  /// Returns a shallow copy of this [UpdateProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UpdateProjectRequest copyWith({
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
  }) {
    return UpdateProjectRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      genres: genres ?? this.genres.map((e0) => e0).toList(),
      visibility: visibility ?? this.visibility,
      allowContributions: allowContributions ?? this.allowContributions,
    );
  }
}
