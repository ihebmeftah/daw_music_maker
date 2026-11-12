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

/// Permission to upload one file.
abstract class SampleUploadTicket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SampleUploadTicket._({
    required this.uploadId,
    required this.uploadDescription,
  });

  factory SampleUploadTicket({
    required _isc.UuidValue uploadId,
    required String uploadDescription,
  }) = _SampleUploadTicketImpl;

  factory SampleUploadTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return SampleUploadTicket(
      uploadId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploadId'],
      ),
      uploadDescription: jsonSerialization['uploadDescription'] as String,
    );
  }

  /// Id to pass to `finishUpload`.
  _isc.UuidValue uploadId;

  /// Serverpod upload description for `FileUploader`.
  String uploadDescription;

  /// Returns a shallow copy of this [SampleUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SampleUploadTicket copyWith({
    _isc.UuidValue? uploadId,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SampleUploadTicket',
      'uploadId': uploadId.toJson(),
      'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SampleUploadTicket',
      'uploadId': uploadId.toJson(),
      'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SampleUploadTicketImpl extends SampleUploadTicket {
  _SampleUploadTicketImpl({
    required _isc.UuidValue uploadId,
    required String uploadDescription,
  }) : super._(
         uploadId: uploadId,
         uploadDescription: uploadDescription,
       );

  /// Returns a shallow copy of this [SampleUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SampleUploadTicket copyWith({
    _isc.UuidValue? uploadId,
    String? uploadDescription,
  }) {
    return SampleUploadTicket(
      uploadId: uploadId ?? this.uploadId,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
