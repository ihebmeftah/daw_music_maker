import '../../../core/validation/validation_rules.dart';
import '../../../core/validation/validator.dart';
import '../../../generated/protocol.dart';

/// Normalized, validated project details.
typedef ProjectDetails = ({
  String name,
  String description,
  List<String> genres,
  ProjectVisibility visibility,
  bool allowContributions,
});

/// Pure validation and access rules of the projects feature (no database).
abstract final class ProjectRules {
  /// Trims [genres], drops empty tags and case-insensitive duplicates (first
  /// spelling wins).
  static List<String> normalizeGenres(List<String> genres) {
    final seen = <String>{};
    final result = <String>[];
    for (final raw in genres) {
      final tag = raw.trim();
      if (tag.isEmpty) continue;
      if (seen.add(tag.toLowerCase())) result.add(tag);
    }
    return result;
  }

  /// Validates and normalizes project details.
  ///
  /// Throws [AppException] with [ErrorCode.validation] and per-field errors
  /// (`name`, `description`, `genres`).
  static ProjectDetails validateDetails({
    required String name,
    required String description,
    required List<String> genres,
    required ProjectVisibility visibility,
    required bool allowContributions,
  }) {
    final v = Validator();
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();
    final tags = normalizeGenres(genres);

    if (trimmedName.isEmpty) {
      v.add('name', 'Name is required');
    } else if (trimmedName.length > ValidationRules.projectNameMaxLength) {
      v.add(
        'name',
        'Name must be at most ${ValidationRules.projectNameMaxLength} characters',
      );
    }
    if (trimmedDescription.length >
        ValidationRules.projectDescriptionMaxLength) {
      v.add(
        'description',
        'Description must be at most '
            '${ValidationRules.projectDescriptionMaxLength} characters',
      );
    }
    if (tags.length > ValidationRules.projectGenresMax) {
      v.add(
        'genres',
        'Use at most ${ValidationRules.projectGenresMax} genres',
      );
    } else if (tags.any((t) => t.length > ValidationRules.genreMaxLength)) {
      v.add(
        'genres',
        'Each genre must be at most ${ValidationRules.genreMaxLength} characters',
      );
    }
    v.throwIfInvalid();

    return (
      name: trimmedName,
      description: trimmedDescription,
      genres: tags,
      visibility: visibility,
      allowContributions: allowContributions,
    );
  }

  /// Validates and normalizes an invitee email.
  ///
  /// Throws [AppException] with [ErrorCode.validation] (`email` field).
  static String validateEmail(String email) {
    final normalized = email.trim().toLowerCase();
    final v = Validator();
    if (normalized.isEmpty) {
      v.add('email', 'Email is required');
    } else if (normalized.length > ValidationRules.emailMaxLength ||
        !ValidationRules.emailPattern.hasMatch(normalized)) {
      v.add('email', 'Enter a valid email address');
    }
    v.throwIfInvalid();
    return normalized;
  }

  /// Normalizes a discover search query: trimmed, capped, `null` when empty.
  static String? normalizeQuery(String? query) {
    final q = query?.trim() ?? '';
    if (q.isEmpty) return null;
    return q.length > ValidationRules.searchQueryMaxLength
        ? q.substring(0, ValidationRules.searchQueryMaxLength)
        : q;
  }

  /// Escapes `%`, `_` and `\` so [text] matches literally in a LIKE pattern.
  static String escapeLike(String text) =>
      text.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');

  /// Whether [access] may change name, description and genres.
  static bool canEditDetails(ProjectAccess access) =>
      access == ProjectAccess.owner || access == ProjectAccess.write;

  /// Whether a non-owner update would change owner-only settings.
  static bool changesOwnerSettings(Project project, ProjectDetails details) =>
      project.visibility != details.visibility ||
      project.allowContributions != details.allowContributions;

  /// Whether [project] currently accepts join requests.
  static bool acceptsJoinRequests(Project project) =>
      project.visibility == ProjectVisibility.public &&
      project.allowContributions;
}
