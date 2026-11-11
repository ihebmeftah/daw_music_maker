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

  // ── Projects ─────────────────────────────────────────────────────────────

  /// Maximum project name length (after trimming; minimum is 1).
  static const int projectNameMaxLength = 80;

  /// Maximum project description length (after trimming; may be empty).
  static const int projectDescriptionMaxLength = 1000;

  /// Maximum number of genre tags per project.
  static const int projectGenresMax = 8;

  /// Maximum length of one genre tag (after trimming; minimum is 1).
  static const int genreMaxLength = 24;

  /// Maximum collaborators per project (members + pending invitations,
  /// excluding the owner).
  static const int projectMembersMax = 50;

  /// Maximum length of a discover search query.
  static const int searchQueryMaxLength = 80;

  /// Slowest allowed tempo in beats per minute.
  static const double bpmMin = 20;

  /// Fastest allowed tempo in beats per minute.
  static const double bpmMax = 999;

  /// Email shape check (`local@domain.tld`), same as the Flutter app.
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
}
