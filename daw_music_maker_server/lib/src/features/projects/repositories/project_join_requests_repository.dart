import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [ProjectJoinRequest] rows. No business rules.
class ProjectJoinRequestsRepository {
  /// Creates the repository.
  const ProjectJoinRequestsRepository();

  /// Finds a request by id.
  Future<ProjectJoinRequest?> findById(Session session, UuidValue id) =>
      ProjectJoinRequest.db.findById(session, id);

  /// The pending request of [userId] for [projectId], if any.
  Future<ProjectJoinRequest?> findFor(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) => ProjectJoinRequest.db.findFirstRow(
    session,
    where: (t) => t.projectId.equals(projectId) & t.userId.equals(userId),
  );

  /// Pending requests for [projectId], oldest first.
  Future<List<ProjectJoinRequest>> listForProject(
    Session session,
    UuidValue projectId,
  ) => ProjectJoinRequest.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderBy: (t) => t.createdAt,
  );

  /// Pending requests sent by [userId], newest first.
  Future<List<ProjectJoinRequest>> listForUser(
    Session session,
    UuidValue userId,
  ) => ProjectJoinRequest.db.find(
    session,
    where: (t) => t.userId.equals(userId),
    orderBy: (t) => t.createdAt.desc(),
  );

  /// Ids of [projectIds] that [userId] has a pending request for.
  Future<Set<UuidValue>> pendingProjectIds(
    Session session,
    UuidValue userId,
    Set<UuidValue> projectIds,
  ) async {
    if (projectIds.isEmpty) return {};
    final rows = await ProjectJoinRequest.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.projectId.inSet(projectIds),
    );
    return {for (final r in rows) r.projectId};
  }

  /// Inserts [request].
  Future<ProjectJoinRequest> insert(
    Session session,
    ProjectJoinRequest request,
  ) => ProjectJoinRequest.db.insertRow(session, request);

  /// Updates [request].
  Future<ProjectJoinRequest> update(
    Session session,
    ProjectJoinRequest request,
  ) => ProjectJoinRequest.db.updateRow(session, request);

  /// Deletes [request].
  Future<void> delete(
    Session session,
    ProjectJoinRequest request, {
    Transaction? transaction,
  }) => ProjectJoinRequest.db.deleteRow(
    session,
    request,
    transaction: transaction,
  );

  /// Deletes every pending request for [projectId].
  Future<void> deleteForProject(
    Session session,
    UuidValue projectId, {
    Transaction? transaction,
  }) => ProjectJoinRequest.db.deleteWhere(
    session,
    where: (t) => t.projectId.equals(projectId),
    transaction: transaction,
  );
}
