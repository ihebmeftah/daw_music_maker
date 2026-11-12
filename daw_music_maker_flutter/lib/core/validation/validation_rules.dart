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

  /// Maximum project name length (after trimming; minimum is 1).
  static const int projectNameMaxLength = 80;

  /// Maximum project description length (after trimming).
  static const int projectDescriptionMaxLength = 1000;

  /// Maximum number of genre tags per project.
  static const int projectGenresMax = 8;

  /// Maximum length of one genre tag.
  static const int genreMaxLength = 24;

  /// Maximum collaborators per project (members + pending invitations).
  static const int projectMembersMax = 50;

  /// Maximum length of a discover search query.
  static const int searchQueryMaxLength = 80;

  /// Slowest allowed tempo in beats per minute.
  static const double bpmMin = 20;

  /// Fastest allowed tempo in beats per minute.
  static const double bpmMax = 999;

  /// Maximum pattern name length (after trimming; minimum is 1).
  static const int patternNameMaxLength = 40;

  /// Number of colors in the pattern palette.
  static const int patternColorCount = 8;

  /// Allowed pattern lengths offered in the UI, in bars (server: 1–16).
  static const List<int> patternLengths = [1, 2, 4, 8, 16];

  /// Maximum patterns per project.
  static const int patternsMax = 99;

  /// Pulses per quarter note: all note times are integer ticks.
  static const int ppq = 960;

  /// Ticks of one bar (4/4).
  static const int ticksPerBar = ppq * 4;

  /// Ticks of one step (1/16 note).
  static const int stepTicks = ppq ~/ 4;

  /// Steps per bar.
  static const int stepsPerBar = 16;

  /// Pitch that plays a sample unpitched (C5 in FL Studio naming).
  static const int rootPitch = 60;

  /// Velocity of new notes.
  static const int defaultVelocity = 100;

  /// Maximum channels per project.
  static const int channelsMax = 32;

  /// Maximum notes per pattern.
  static const int notesPerPatternMax = 4096;

  /// Number of playlist tracks (rows).
  static const int playlistTracks = 16;

  /// Song length limit in bars.
  static const int playlistBarsMax = 256;

  /// Maximum clips in a playlist.
  static const int playlistClipsMax = 2048;

  /// Largest audio upload (10 MB), checked before uploading.
  static const int sampleMaxBytes = 10 * 1024 * 1024;

  /// Audio file extensions accepted for uploads.
  static const Set<String> sampleExtensions = {
    'wav',
    'wave',
    'mp3',
    'ogg',
    'oga',
    'flac',
  };

  /// Sampler pitch range in semitones (±).
  static const int samplerPitchRange = 24;

  /// Allowed numbers of slices when chopping.
  static const List<int> chopSlices = [2, 4, 8, 16];

  /// Smallest sampler region (fraction of the sample).
  static const double regionMinFrac = 0.001;

  /// Longest audio clip on the playlist, in bars.
  static const int audioClipBarsMax = 64;

  /// Pragmatic email shape check: `local@domain.tld`, no whitespace.
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Verification codes contain only the digits 1–9.
  static final RegExp verificationCodePattern = RegExp(r'^[1-9]+$');
}
