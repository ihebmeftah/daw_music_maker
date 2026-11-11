/// Categories of failures the UI knows how to explain to the user.
enum FailureCode {
  /// Email or password is wrong.
  invalidCredentials,

  /// Rate limit hit (logins, codes or reset requests).
  tooManyAttempts,

  /// A verification code or request has expired.
  codeExpired,

  /// A verification code is wrong or the request no longer exists.
  codeInvalid,

  /// The password does not comply with the server's password policy.
  passwordPolicy,

  /// The account has been blocked by an administrator.
  accountBlocked,

  /// The server could not be reached.
  network,

  /// The resource does not exist or is not visible to the user.
  notFound,

  /// The user's role does not allow this action.
  forbidden,

  /// The server rejected the input; see [Failure.fieldErrors].
  validation,

  /// The action conflicts with the current state (e.g. already a member).
  conflict,

  /// A limit was reached (e.g. collaborators per project).
  limitReached,

  /// Anything else; details are only logged, never shown.
  unknown;

  /// User-friendly explanation shown in the UI. Never contains raw server text.
  String get message => switch (this) {
    FailureCode.invalidCredentials => 'Wrong email or password.',
    FailureCode.tooManyAttempts =>
      'Too many attempts. Take a breather and try again in a few minutes.',
    FailureCode.codeExpired => 'That code has expired. Request a new one.',
    FailureCode.codeInvalid => 'That code is not valid. Check your email.',
    FailureCode.passwordPolicy =>
      'This password does not meet the requirements.',
    FailureCode.accountBlocked =>
      'This account has been blocked. Contact support.',
    FailureCode.network =>
      'Cannot reach the studio server. Check your connection.',
    FailureCode.notFound => 'This was not found — it may have been removed.',
    FailureCode.forbidden => 'You do not have permission to do that.',
    FailureCode.validation => 'Some fields need your attention.',
    FailureCode.conflict => 'That is already done.',
    FailureCode.limitReached => 'This project has reached its limit.',
    FailureCode.unknown => 'Something went wrong. Please try again.',
  };
}

/// A typed, user-presentable error thrown by repositories.
///
/// ViewModels catch [Failure]s and store them in their state; views render
/// [message].
class Failure implements Exception {
  /// Creates a failure of the given [code], with optional server-side
  /// [fieldErrors] (keyed by request field name).
  const Failure(this.code, {this.fieldErrors = const {}});

  /// What went wrong.
  final FailureCode code;

  /// Per-field validation messages from the server (e.g. `{'name': '…'}`).
  final Map<String, String> fieldErrors;

  /// The server message for [field], if any.
  String? fieldError(String field) => fieldErrors[field];

  /// User-friendly message for [code].
  String get message => code.message;

  @override
  bool operator ==(Object other) => other is Failure && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Failure(${code.name})';
}
