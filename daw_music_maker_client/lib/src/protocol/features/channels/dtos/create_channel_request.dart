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
import '../../../features/channels/enums/sample_kind.dart' as _ixhlpt54;

/// Input for adding a channel (owner or write member). Exactly one of
/// [sample] (built-in) and [sampleId] (uploaded) must be set.
abstract class CreateChannelRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CreateChannelRequest._({
    required this.projectId,
    this.sample,
    this.sampleId,
    this.name,
  });

  factory CreateChannelRequest({
    required _isc.UuidValue projectId,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId,
    String? name,
  }) = _CreateChannelRequestImpl;

  factory CreateChannelRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CreateChannelRequest(
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      sample: jsonSerialization['sample'] == null
          ? null
          : _ixhlpt54.SampleKind.fromJson(
              (jsonSerialization['sample'] as String),
            ),
      sampleId: jsonSerialization['sampleId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['sampleId']),
      name: jsonSerialization['name'] as String?,
    );
  }

  /// The project.
  _isc.UuidValue projectId;

  /// A built-in sample to play.
  _ixhlpt54.SampleKind? sample;

  /// An uploaded sample of the project to play.
  _isc.UuidValue? sampleId;

  /// Optional name (1–40 chars); defaults to the sample's name.
  String? name;

  /// Returns a shallow copy of this [CreateChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CreateChannelRequest copyWith({
    _isc.UuidValue? projectId,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateChannelRequest',
      'projectId': projectId.toJson(),
      if (sample != null) 'sample': sample?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (name != null) 'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreateChannelRequest',
      'projectId': projectId.toJson(),
      if (sample != null) 'sample': sample?.toJson(),
      if (sampleId != null) 'sampleId': sampleId?.toJson(),
      if (name != null) 'name': name,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreateChannelRequestImpl extends CreateChannelRequest {
  _CreateChannelRequestImpl({
    required _isc.UuidValue projectId,
    _ixhlpt54.SampleKind? sample,
    _isc.UuidValue? sampleId,
    String? name,
  }) : super._(
         projectId: projectId,
         sample: sample,
         sampleId: sampleId,
         name: name,
       );

  /// Returns a shallow copy of this [CreateChannelRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CreateChannelRequest copyWith({
    _isc.UuidValue? projectId,
    Object? sample = _Undefined,
    _isc.UuidValue? sampleId = const _isc.$UndefinedUuidValue(),
    Object? name = _Undefined,
  }) {
    return CreateChannelRequest(
      projectId: projectId ?? this.projectId,
      sample: sample is _ixhlpt54.SampleKind? ? sample : this.sample,
      sampleId: sampleId is _isc.UndefinedSentinel ? this.sampleId : sampleId,
      name: name is String? ? name : this.name,
    );
  }
}
