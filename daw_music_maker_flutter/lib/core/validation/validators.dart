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

  /// Validates a required project name (1–80 chars after trimming).
  static String? projectName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Give your project a name';
    if (name.length > ValidationRules.projectNameMaxLength) {
      return 'Use at most ${ValidationRules.projectNameMaxLength} characters';
    }
    return null;
  }

  /// Validates an optional project description (max 1000 chars).
  static String? projectDescription(String? value) {
    final description = value?.trim() ?? '';
    if (description.length > ValidationRules.projectDescriptionMaxLength) {
      return 'Use at most '
          '${ValidationRules.projectDescriptionMaxLength} characters';
    }
    return null;
  }

  /// Validates a genre tag about to be added to [existing] tags.
  static String? genreTag(String? value, List<String> existing) {
    final tag = value?.trim() ?? '';
    if (tag.isEmpty) return 'Type a genre';
    if (tag.length > ValidationRules.genreMaxLength) {
      return 'Use at most ${ValidationRules.genreMaxLength} characters';
    }
    if (existing.length >= ValidationRules.projectGenresMax) {
      return 'Up to ${ValidationRules.projectGenresMax} genres';
    }
    if (existing.any((g) => g.toLowerCase() == tag.toLowerCase())) {
      return 'Already added';
    }
    return null;
  }

  /// Validates a typed tempo (20–999 BPM, decimals allowed).
  static String? bpm(String? value) {
    final text = value?.trim().replaceAll(',', '.') ?? '';
    if (text.isEmpty) return 'Enter a tempo';
    final bpm = double.tryParse(text);
    if (bpm == null || !bpm.isFinite) return 'Enter a number';
    if (bpm < ValidationRules.bpmMin || bpm > ValidationRules.bpmMax) {
      return '${ValidationRules.bpmMin.toInt()}–'
          '${ValidationRules.bpmMax.toInt()} BPM';
    }
    return null;
  }
}
