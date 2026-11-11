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
import '../../../features/projects/responses/project_response.dart'
    as _ip0ft6zl;

/// One page of projects.
abstract class ProjectPageResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectPageResponse._({
    required this.items,
    required this.hasMore,
  });

  factory ProjectPageResponse({
    required List<_ip0ft6zl.ProjectResponse> items,
    required bool hasMore,
  }) = _ProjectPageResponseImpl;

  factory ProjectPageResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectPageResponse(
      items: _i5v019zt.Protocol().deserialize<List<_ip0ft6zl.ProjectResponse>>(
        jsonSerialization['items'],
      ),
      hasMore: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
    );
  }

  /// Projects on this page.
  List<_ip0ft6zl.ProjectResponse> items;

  /// Whether more projects exist after this page.
  bool hasMore;

  /// Returns a shallow copy of this [ProjectPageResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectPageResponse copyWith({
    List<_ip0ft6zl.ProjectResponse>? items,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectPageResponse',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'hasMore': hasMore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectPageResponse',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'hasMore': hasMore,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProjectPageResponseImpl extends ProjectPageResponse {
  _ProjectPageResponseImpl({
    required List<_ip0ft6zl.ProjectResponse> items,
    required bool hasMore,
  }) : super._(
         items: items,
         hasMore: hasMore,
       );

  /// Returns a shallow copy of this [ProjectPageResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectPageResponse copyWith({
    List<_ip0ft6zl.ProjectResponse>? items,
    bool? hasMore,
  }) {
    return ProjectPageResponse(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
