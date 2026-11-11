import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [ProjectMember] rows. No business rules.
class ProjectMembersRepository {
  /// Creates the repository.
  const ProjectMembersRepository();

  /// The membership of [userId] in [projectId], if any.
  Future<ProjectMember?> find(
    Session session,
    UuidValue projectId,
    UuidValue userId, {
    Transaction? transaction,
  }) => ProjectMember.db.findFirstRow(
    session,
    where: (t) => t.projectId.equals(projectId) & t.userId.equals(userId),
    transaction: transaction,
  );

  /// All members of [projectId], oldest first.
  Future<List<ProjectMember>> listForProject(
    Session session,
    UuidValue projectId,
  ) => ProjectMember.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderBy: (t) => t.createdAt,
  );

  /// Memberships of [userId] in any of [projectIds].
  Future<List<ProjectMember>> listForUserIn(
    Session session,
    UuidValue userId,
    Set<UuidValue> projectIds,
  ) async {
    if (projectIds.isEmpty) return [];
    return ProjectMember.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.projectId.inSet(projectIds),
    );
  }

  /// Number of members per project for [projectIds].
  Future<Map<UuidValue, int>> countByProject(
    Session session,
    Set<UuidValue> projectIds,
  ) async {
    if (projectIds.isEmpty) return {};
    final rows = await ProjectMember.db.find(
      session,
      where: (t) => t.projectId.inSet(projectIds),
    );
    final counts = <UuidValue, int>{};
    for (final row in rows) {
      counts[row.projectId] = (counts[row.projectId] ?? 0) + 1;
    }
    return counts;
  }

  /// Number of members of [projectId].
  Future<int> count(
    Session session,
    UuidValue projectId, {
    Transaction? transaction,
  }) => ProjectMember.db.count(
    session,
    where: (t) => t.projectId.equals(projectId),
    transaction: transaction,
  );

  /// Inserts [member].
  Future<ProjectMember> insert(
    Session session,
    ProjectMember member, {
    Transaction? transaction,
  }) => ProjectMember.db.insertRow(session, member, transaction: transaction);

  /// Updates [member].
  Future<ProjectMember> update(Session session, ProjectMember member) =>
      ProjectMember.db.updateRow(session, member);

  /// Deletes [member].
  Future<void> delete(Session session, ProjectMember member) =>
      ProjectMember.db.deleteRow(session, member);
}
