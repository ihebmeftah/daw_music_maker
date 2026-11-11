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
    FailureCode.unknown => 'Something went wrong. Please try again.',
  };
}

/// A typed, user-presentable error thrown by repositories.
///
/// ViewModels catch [Failure]s and store them in their state; views render
/// [message].
class Failure implements Exception {
  /// Creates a failure of the given [code].
  const Failure(this.code);

  /// What went wrong.
  final FailureCode code;

  /// User-friendly message for [code].
  String get message => code.message;

  @override
  bool operator ==(Object other) => other is Failure && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Failure(${code.name})';
}
