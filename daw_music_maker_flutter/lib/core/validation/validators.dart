import 'validation_rules.dart';

/// Pure form validators. Each returns an error message, or `null` when valid.
///
/// Use them as `TextFormField.validator`s:
///
/// ```dart
/// DawTextField(validator: Validators.email)
/// ```
abstract final class Validators {
  /// Validates a required email address against [ValidationRules].
  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email';
    if (email.length > ValidationRules.emailMaxLength) {
      return 'Email must be at most ${ValidationRules.emailMaxLength} characters';
    }
    if (!ValidationRules.emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password for sign-in: only required, since the policy may
  /// have changed after the account was created.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    return null;
  }

  /// Validates a new password against the server's password policy.
  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Choose a password';
    if (password.length < ValidationRules.passwordMinLength) {
      return 'Use at least ${ValidationRules.passwordMinLength} characters';
    }
    if (password.length > ValidationRules.passwordMaxLength) {
      return 'Use at most ${ValidationRules.passwordMaxLength} characters';
    }
    if (password.trim() != password) {
      return 'Password cannot start or end with a space';
    }
    return null;
  }

  /// Returns a validator that checks the value equals [password]().
  ///
  /// [password] is a callback so the latest field value is compared.
  static String? Function(String?) confirmPassword(
    String Function() password,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return 'Repeat your password';
      if (value != password()) return 'Passwords do not match';
      return null;
    };
  }

  /// Validates an emailed verification code.
  static String? verificationCode(String? value) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) return 'Enter the code from your email';
    if (code.length != ValidationRules.verificationCodeLength ||
        !ValidationRules.verificationCodePattern.hasMatch(code)) {
      return 'The code has ${ValidationRules.verificationCodeLength} digits';
    }
    return null;
  }
}
