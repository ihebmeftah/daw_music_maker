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
import '../../core/exceptions/error_code.dart' as _i0o8jczr;

/// The only exception feature endpoints throw to the client. Never contains
/// stack traces, SQL or other internal details.
abstract class AppException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  AppException._({
    required this.code,
    this.message,
    this.fieldErrors,
  });

  factory AppException({
    required _i0o8jczr.ErrorCode code,
    String? message,
    Map<String, String>? fieldErrors,
  }) = _AppExceptionImpl;

  factory AppException.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppException(
      code: _i0o8jczr.ErrorCode.fromJson((jsonSerialization['code'] as String)),
      message: jsonSerialization['message'] as String?,
      fieldErrors: jsonSerialization['fieldErrors'] == null
          ? null
          : _iau3psze.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['fieldErrors'],
            ),
    );
  }

  /// What went wrong.
  _i0o8jczr.ErrorCode code;

  /// Optional developer-oriented summary (safe to show, never internal).
  String? message;

  /// Per-field validation errors, keyed by DTO field name.
  Map<String, String>? fieldErrors;

  /// Returns a shallow copy of this [AppException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AppException copyWith({
    _i0o8jczr.ErrorCode? code,
    String? message,
    Map<String, String>? fieldErrors =
        const _is.$UndefinedMap<String, String>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppException',
      'code': code.toJson(),
      if (message != null) 'message': message,
      if (fieldErrors != null) 'fieldErrors': fieldErrors?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppException',
      'code': code.toJson(),
      if (message != null) 'message': message,
      if (fieldErrors != null) 'fieldErrors': fieldErrors?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AppException(code: $code, message: $message, fieldErrors: $fieldErrors)';
  }
}

class _Undefined {}

class _AppExceptionImpl extends AppException {
  _AppExceptionImpl({
    required _i0o8jczr.ErrorCode code,
    String? message,
    Map<String, String>? fieldErrors,
  }) : super._(
         code: code,
         message: message,
         fieldErrors: fieldErrors,
       );

  /// Returns a shallow copy of this [AppException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AppException copyWith({
    _i0o8jczr.ErrorCode? code,
    Object? message = _Undefined,
    Map<String, String>? fieldErrors =
        const _is.$UndefinedMap<String, String>(),
  }) {
    return AppException(
      code: code ?? this.code,
      message: message is String? ? message : this.message,
      fieldErrors: fieldErrors is _is.UndefinedSentinel
          ? this.fieldErrors?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : fieldErrors,
    );
  }
}
