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

/// Registers an uploaded file as a sample once the upload finished.
abstract class FinishSampleUploadRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FinishSampleUploadRequest._({
    required this.projectId,
    required this.uploadId,
    required this.fileName,
    this.durationMs,
  });

  factory FinishSampleUploadRequest({
    required _isc.UuidValue projectId,
    required _isc.UuidValue uploadId,
    required String fileName,
    int? durationMs,
  }) = _FinishSampleUploadRequestImpl;

  factory FinishSampleUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FinishSampleUploadRequest(
      projectId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['projectId'],
      ),
      uploadId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploadId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      durationMs: jsonSerialization['durationMs'] as int?,
    );
  }

  /// The project.
  _isc.UuidValue projectId;

  /// The id returned by `requestUpload`.
  _isc.UuidValue uploadId;

  /// Original file name.
  String fileName;

  /// Duration measured by the client (used for non-WAV files, ≤ 10 min).
  int? durationMs;

  /// Returns a shallow copy of this [FinishSampleUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FinishSampleUploadRequest copyWith({
    _isc.UuidValue? projectId,
    _isc.UuidValue? uploadId,
    String? fileName,
    int? durationMs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FinishSampleUploadRequest',
      'projectId': projectId.toJson(),
      'uploadId': uploadId.toJson(),
      'fileName': fileName,
      if (durationMs != null) 'durationMs': durationMs,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FinishSampleUploadRequest',
      'projectId': projectId.toJson(),
      'uploadId': uploadId.toJson(),
      'fileName': fileName,
      if (durationMs != null) 'durationMs': durationMs,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FinishSampleUploadRequestImpl extends FinishSampleUploadRequest {
  _FinishSampleUploadRequestImpl({
    required _isc.UuidValue projectId,
    required _isc.UuidValue uploadId,
    required String fileName,
    int? durationMs,
  }) : super._(
         projectId: projectId,
         uploadId: uploadId,
         fileName: fileName,
         durationMs: durationMs,
       );

  /// Returns a shallow copy of this [FinishSampleUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FinishSampleUploadRequest copyWith({
    _isc.UuidValue? projectId,
    _isc.UuidValue? uploadId,
    String? fileName,
    Object? durationMs = _Undefined,
  }) {
    return FinishSampleUploadRequest(
      projectId: projectId ?? this.projectId,
      uploadId: uploadId ?? this.uploadId,
      fileName: fileName ?? this.fileName,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
    );
  }
}
