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

/// Machine-readable category of an [AppException]. The client maps each code
/// to a user-friendly message.
enum ErrorCode implements _is.SerializableModel {
  /// The resource does not exist or the caller may not see it (also used for
  /// resources owned by someone else, so ids cannot be probed).
  notFound,

  /// The caller can see the resource but may not perform this action.
  forbidden,

  /// The request failed validation; see [AppException.fieldErrors].
  validation,

  /// The request conflicts with the current state (e.g. already a member).
  conflict,

  /// A configured limit (e.g. members per project) has been reached.
  limitReached;

  static ErrorCode fromJson(String name) {
    switch (name) {
      case 'notFound':
        return ErrorCode.notFound;
      case 'forbidden':
        return ErrorCode.forbidden;
      case 'validation':
        return ErrorCode.validation;
      case 'conflict':
        return ErrorCode.conflict;
      case 'limitReached':
        return ErrorCode.limitReached;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ErrorCode"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
