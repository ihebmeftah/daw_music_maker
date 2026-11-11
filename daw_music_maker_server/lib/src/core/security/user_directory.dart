import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Resolves auth users to their email addresses (and back).
///
/// Emails are personal data: only call this where the feature explicitly
/// allows the caller to see them (see `docs/features/projects.md`).
class UserDirectory {
  /// Creates a directory.
  const UserDirectory();

  /// Normalizes an email the way the email identity provider stores it.
  static String normalize(String email) => email.trim().toLowerCase();

  /// The email of [userId], or null if the user has no email account.
  Future<String?> emailOf(Session session, UuidValue userId) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    return account?.email;
  }

  /// Emails of [userIds], keyed by user id. Users without an email account
  /// are missing from the result.
  Future<Map<UuidValue, String>> emailsOf(
    Session session,
    Set<UuidValue> userIds,
  ) async {
    if (userIds.isEmpty) return {};
    final accounts = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.inSet(userIds),
    );
    return {for (final a in accounts) a.authUserId: a.email};
  }

  /// The user registered with [email], or null.
  Future<UuidValue?> userIdForEmail(Session session, String email) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalize(email)),
    );
    return account?.authUserId;
  }
}
