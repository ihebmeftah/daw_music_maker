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

  // ── Patterns ─────────────────────────────────────────────────────────────

  /// Maximum pattern name length (after trimming; minimum is 1).
  static const int patternNameMaxLength = 40;

  /// Number of colors in the pattern palette (indexes 0..count-1).
  static const int patternColorCount = 8;

  /// Shortest pattern, in bars.
  static const int patternLengthMin = 1;

  /// Longest pattern, in bars.
  static const int patternLengthMax = 16;

  /// Length of new patterns, in bars.
  static const int patternLengthDefault = 4;

  /// Maximum patterns per project.
  static const int patternsMax = 99;

  // ── Channels & notes ─────────────────────────────────────────────────────

  /// Pulses per quarter note: all note times are integer ticks.
  static const int ppq = 960;

  /// Ticks of one bar (4/4).
  static const int ticksPerBar = ppq * 4;

  /// Ticks of one step-sequencer step (a 1/16 note).
  static const int stepTicks = ppq ~/ 4;

  /// Maximum channel name length (after trimming; minimum is 1).
  static const int channelNameMaxLength = 40;

  /// Maximum channels per project.
  static const int channelsMax = 32;

  /// Maximum notes per pattern.
  static const int notesPerPatternMax = 4096;

  /// Lowest / highest MIDI pitch.
  static const int pitchMin = 0;

  /// Highest MIDI pitch.
  static const int pitchMax = 127;

  /// Lowest MIDI velocity (0 would be silent).
  static const int velocityMin = 1;

  /// Highest MIDI velocity.
  static const int velocityMax = 127;

  // ── Playlist ─────────────────────────────────────────────────────────────

  /// Number of playlist tracks (rows).
  static const int playlistTracks = 16;

  /// Song length limit in bars (clips must end within it).
  static const int playlistBarsMax = 256;

  /// Maximum clips in a playlist.
  static const int playlistClipsMax = 2048;

  // ── Samples ──────────────────────────────────────────────────────────────

  /// Largest audio upload (10 MB).
  static const int sampleMaxBytes = 10 * 1024 * 1024;

  /// Maximum length of an uploaded file name.
  static const int sampleFileNameMaxLength = 200;

  /// Longest duration accepted from clients (10 minutes).
  static const int sampleMaxDurationMs = 10 * 60 * 1000;

  /// Maximum samples per project.
  static const int samplesMax = 64;

  /// Sampler pitch range in semitones (±).
  static const int samplerPitchRange = 24;

  /// Allowed numbers of slices when chopping a sample.
  static const Set<int> chopSlices = {2, 4, 8, 16};

  /// Smallest sampler region (fraction of the sample).
  static const double regionMinFrac = 0.001;

  /// Longest audio clip on the playlist, in bars.
  static const int audioClipBarsMax = 64;

  /// Email shape check (`local@domain.tld`), same as the Flutter app.
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
}
