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

/// Input for creating a project. Validated by the server.
abstract class CreateProjectRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CreateProjectRequest._({
    required this.name,
    required this.description,
    required this.genres,
    required this.visibility,
    required this.allowContributions,
  });

  factory CreateProjectRequest({
    required String name,
    required String description,
    required List<String> genres,
    required _iih43j5r.ProjectVisibility visibility,
    required bool allowContributions,
  }) = _CreateProjectRequestImpl;

  factory CreateProjectRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CreateProjectRequest(
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

  /// Who can see the project.
  _iih43j5r.ProjectVisibility visibility;

  /// Whether collaborators can be invited / request to join.
  bool allowContributions;

  /// Returns a shallow copy of this [CreateProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CreateProjectRequest copyWith({
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateProjectRequest',
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
      '__className__': 'CreateProjectRequest',
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

class _CreateProjectRequestImpl extends CreateProjectRequest {
  _CreateProjectRequestImpl({
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

  /// Returns a shallow copy of this [CreateProjectRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CreateProjectRequest copyWith({
    String? name,
    String? description,
    List<String>? genres,
    _iih43j5r.ProjectVisibility? visibility,
    bool? allowContributions,
  }) {
    return CreateProjectRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      genres: genres ?? this.genres.map((e0) => e0).toList(),
      visibility: visibility ?? this.visibility,
      allowContributions: allowContributions ?? this.allowContributions,
    );
  }
}
