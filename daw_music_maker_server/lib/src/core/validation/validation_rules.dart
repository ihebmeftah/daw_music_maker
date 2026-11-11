/// Validation limits enforced by the server.
///
/// The Flutter app mirrors these values in
/// `daw_music_maker_flutter/lib/core/validation/validation_rules.dart`.
/// Change both files together and keep their tests in sync.
abstract final class ValidationRules {
  /// Maximum length of an email address (RFC 5321 path limit).
  static const int emailMaxLength = 254;

  /// Minimum password length.
  ///
  /// Matches Serverpod's `defaultRegistrationPasswordValidationFunction`,
  /// which the email identity provider uses to enforce the policy on
  /// registration and password reset.
  static const int passwordMinLength = 8;

  /// Maximum password length accepted by the app (guards against very large
  /// payloads being hashed).
  static const int passwordMaxLength = 128;

  /// Number of digits in registration and password-reset verification codes.
  ///
  /// Matches Serverpod's `defaultVerificationCodeGenerator` (digits 1–9).
  static const int verificationCodeLength = 8;
}
