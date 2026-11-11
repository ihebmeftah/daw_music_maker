import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [Project] rows. No business rules.
class ProjectsRepository {
  /// Creates the repository.
  const ProjectsRepository();

  /// Finds a project by id (no access check — callers must check).
  Future<Project?> findById(Session session, UuidValue id) =>
      Project.db.findById(session, id);

  /// Projects with the given [ids], keyed by id.
  Future<Map<UuidValue, Project>> findByIds(
    Session session,
    Set<UuidValue> ids,
  ) async {
    if (ids.isEmpty) return {};
    final rows = await Project.db.find(session, where: (t) => t.id.inSet(ids));
    return {for (final p in rows) p.id!: p};
  }

  /// Inserts [project].
  Future<Project> insert(Session session, Project project) =>
      Project.db.insertRow(session, project);

  /// Updates [project].
  Future<Project> update(
    Session session,
    Project project, {
    Transaction? transaction,
  }) => Project.db.updateRow(session, project, transaction: transaction);

  /// Deletes [project] (members, invitations and requests cascade).
  Future<void> delete(Session session, Project project) =>
      Project.db.deleteRow(session, project);

  /// Projects owned by [ownerId], newest change first. Fetches `limit + 1`
  /// rows so the caller can tell whether more exist.
  Future<List<Project>> listOwned(
    Session session,
    UuidValue ownerId, {
    required int limit,
    required int offset,
  }) => Project.db.find(
    session,
    where: (t) => t.ownerId.equals(ownerId),
    orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    limit: limit + 1,
    offset: offset,
  );

  /// Projects [userId] is a member of (not owner), newest change first.
  Future<List<Project>> listShared(
    Session session,
    UuidValue userId, {
    required int limit,
    required int offset,
  }) => Project.db.find(
    session,
    where: (t) => t.members.any((m) => m.userId.equals(userId)),
    orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    limit: limit + 1,
    offset: offset,
  );

  /// Public projects not owned by [userId], optionally filtered by a LIKE
  /// [namePattern] (already escaped), newest change first.
  Future<List<Project>> listPublic(
    Session session,
    UuidValue userId, {
    String? namePattern,
    required int limit,
    required int offset,
  }) => Project.db.find(
    session,
    where: (t) {
      final base =
          t.visibility.equals(ProjectVisibility.public) &
          t.ownerId.notEquals(userId);
      return namePattern == null ? base : base & t.name.ilike(namePattern);
    },
    orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    limit: limit + 1,
    offset: offset,
  );
}
