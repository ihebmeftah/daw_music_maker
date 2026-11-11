/// Validation limits used by the app's form validators.
///
/// Mirrors `daw_music_maker_server/lib/src/core/validation/validation_rules.dart`.
/// Change both files together and keep their tests in sync. Client-side
/// validation is for UX only; the server always re-validates.
abstract final class ValidationRules {
  /// Maximum length of an email address (RFC 5321 path limit).
  static const int emailMaxLength = 254;

  /// Minimum password length (Serverpod email provider default policy).
  static const int passwordMinLength = 8;

  /// Maximum password length.
  static const int passwordMaxLength = 128;

  /// Number of digits in registration and password-reset verification codes.
  static const int verificationCodeLength = 8;

  /// Pragmatic email shape check: `local@domain.tld`, no whitespace.
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Verification codes contain only the digits 1–9.
  static final RegExp verificationCodePattern = RegExp(r'^[1-9]+$');
}
