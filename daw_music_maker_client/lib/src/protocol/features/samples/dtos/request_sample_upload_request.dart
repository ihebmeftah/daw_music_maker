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

/// Asks for permission to upload an audio file (owner or write member).
abstract class RequestSampleUploadRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RequestSampleUploadRequest._({
    required this.projectId,
    required this.fileName,
    required this.sizeBytes,
  });

  factory RequestSampleUploadRequest({
    required _isc.UuidValue projectId,
    required String fileName,
    required int sizeBytes,
  }) = _RequestSampleUploadRequestImpl;

  factory RequestSampleUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RequestSampleUploadRequest(
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
    );
  }

  /// The project.
  _isc.UuidValue projectId;

  /// Original file name (used for the extension and display name).
  String fileName;

  /// File size in bytes (1 B – 10 MB).
  int sizeBytes;

  /// Returns a shallow copy of this [RequestSampleUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RequestSampleUploadRequest copyWith({
    _isc.UuidValue? projectId,
    String? fileName,
    int? sizeBytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RequestSampleUploadRequest',
      'projectId': projectId.toJson(),
      'fileName': fileName,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RequestSampleUploadRequest',
      'projectId': projectId.toJson(),
      'fileName': fileName,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RequestSampleUploadRequestImpl extends RequestSampleUploadRequest {
  _RequestSampleUploadRequestImpl({
    required _isc.UuidValue projectId,
    required String fileName,
    required int sizeBytes,
  }) : super._(
         projectId: projectId,
         fileName: fileName,
         sizeBytes: sizeBytes,
       );

  /// Returns a shallow copy of this [RequestSampleUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RequestSampleUploadRequest copyWith({
    _isc.UuidValue? projectId,
    String? fileName,
    int? sizeBytes,
  }) {
    return RequestSampleUploadRequest(
      projectId: projectId ?? this.projectId,
      fileName: fileName ?? this.fileName,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
