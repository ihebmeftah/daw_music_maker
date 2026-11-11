import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [ProjectInvitation] rows. No business rules.
class ProjectInvitationsRepository {
  /// Creates the repository.
  const ProjectInvitationsRepository();

  /// Finds an invitation by id.
  Future<ProjectInvitation?> findById(Session session, UuidValue id) =>
      ProjectInvitation.db.findById(session, id);

  /// The pending invitation of [email] to [projectId], if any.
  Future<ProjectInvitation?> findFor(
    Session session,
    UuidValue projectId,
    String email,
  ) => ProjectInvitation.db.findFirstRow(
    session,
    where: (t) => t.projectId.equals(projectId) & t.email.equals(email),
  );

  /// Pending invitations of [projectId], newest first.
  Future<List<ProjectInvitation>> listForProject(
    Session session,
    UuidValue projectId,
  ) => ProjectInvitation.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderBy: (t) => t.createdAt.desc(),
  );

  /// Pending invitations addressed to [email], newest first.
  Future<List<ProjectInvitation>> listForEmail(
    Session session,
    String email,
  ) => ProjectInvitation.db.find(
    session,
    where: (t) => t.email.equals(email),
    orderBy: (t) => t.createdAt.desc(),
  );

  /// Number of pending invitations of [projectId].
  Future<int> count(Session session, UuidValue projectId) =>
      ProjectInvitation.db.count(
        session,
        where: (t) => t.projectId.equals(projectId),
      );

  /// Inserts [invitation].
  Future<ProjectInvitation> insert(
    Session session,
    ProjectInvitation invitation,
  ) => ProjectInvitation.db.insertRow(session, invitation);

  /// Updates [invitation].
  Future<ProjectInvitation> update(
    Session session,
    ProjectInvitation invitation,
  ) => ProjectInvitation.db.updateRow(session, invitation);

  /// Deletes [invitation].
  Future<void> delete(
    Session session,
    ProjectInvitation invitation, {
    Transaction? transaction,
  }) => ProjectInvitation.db.deleteRow(
    session,
    invitation,
    transaction: transaction,
  );

  /// Deletes every pending invitation of [projectId].
  Future<void> deleteForProject(
    Session session,
    UuidValue projectId, {
    Transaction? transaction,
  }) => ProjectInvitation.db.deleteWhere(
    session,
    where: (t) => t.projectId.equals(projectId),
    transaction: transaction,
  );
}
