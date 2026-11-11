import '../../generated/protocol.dart';

/// Collects field errors and throws them as one [AppException].
///
/// ```dart
/// final v = Validator();
/// if (name.isEmpty) v.add('name', 'Name is required');
/// v.throwIfInvalid();
/// ```
class Validator {
  final Map<String, String> _errors = {};

  /// Records an error for [field] (the first error per field wins).
  void add(String field, String message) =>
      _errors.putIfAbsent(field, () => message);

  /// Whether no error was recorded.
  bool get isValid => _errors.isEmpty;

  /// The recorded errors.
  Map<String, String> get errors => Map.unmodifiable(_errors);

  /// Throws [AppException] with [ErrorCode.validation] when any error exists.
  void throwIfInvalid() {
    if (_errors.isEmpty) return;
    throw AppException(
      code: ErrorCode.validation,
      message: 'Validation failed',
      fieldErrors: Map.of(_errors),
    );
  }
}
