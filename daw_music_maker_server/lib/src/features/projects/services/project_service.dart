import 'package:serverpod/serverpod.dart';

import '../../../core/pagination/page_limits.dart';
import '../../../generated/protocol.dart';
import '../mappers/project_mapper.dart';
import '../repositories/project_invitations_repository.dart';
import '../repositories/project_join_requests_repository.dart';
import '../repositories/project_members_repository.dart';
import '../repositories/projects_repository.dart';
import 'project_access_service.dart';
import 'project_rules.dart';

/// Project CRUD and listing.
class ProjectService {
  /// Creates the service.
  const ProjectService();

  static const _projects = ProjectsRepository();
  static const _members = ProjectMembersRepository();
  static const _invitations = ProjectInvitationsRepository();
  static const _joinRequests = ProjectJoinRequestsRepository();
  static const _access = ProjectAccessService();

  /// Creates a project owned by [userId].
  Future<ProjectResponse> create(
    Session session,
    UuidValue userId,
    CreateProjectRequest request,
  ) async {
    final details = ProjectRules.validateDetails(
      name: request.name,
      description: request.description,
      genres: request.genres,
      visibility: request.visibility,
      allowContributions: request.allowContributions,
    );
    final now = DateTime.now().toUtc();
    final project = await _projects.insert(
      session,
      Project(
        ownerId: userId,
        name: details.name,
        description: details.description,
        genres: details.genres,
        visibility: details.visibility,
        allowContributions: details.allowContributions,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return project.toResponse(access: ProjectAccess.owner, memberCount: 0);
  }

  /// Returns a project visible to [userId].
  Future<ProjectResponse> getById(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final (project, access) = await _access.load(session, projectId, userId);
    final memberCount = await _members.count(session, projectId);
    final pending =
        access == ProjectAccess.none &&
        await _joinRequests.findFor(session, projectId, userId) != null;
    return project.toResponse(
      access: access,
      memberCount: memberCount,
      hasPendingJoinRequest: pending,
    );
  }

  /// Projects owned by [userId].
  Future<ProjectPageResponse> listMine(
    Session session,
    UuidValue userId, {
    int? limit,
    int? offset,
  }) async {
    final pageSize = PageLimits.clampLimit(limit);
    final rows = await _projects.listOwned(
      session,
      userId,
      limit: pageSize,
      offset: PageLimits.clampOffset(offset),
    );
    return _page(session, userId, rows, pageSize);
  }

  /// Projects [userId] collaborates on.
  Future<ProjectPageResponse> listShared(
    Session session,
    UuidValue userId, {
    int? limit,
    int? offset,
  }) async {
    final pageSize = PageLimits.clampLimit(limit);
    final rows = await _projects.listShared(
      session,
      userId,
      limit: pageSize,
      offset: PageLimits.clampOffset(offset),
    );
    return _page(session, userId, rows, pageSize);
  }

  /// Public projects of other users, optionally filtered by name.
  Future<ProjectPageResponse> discover(
    Session session,
    UuidValue userId, {
    String? query,
    int? limit,
    int? offset,
  }) async {
    final pageSize = PageLimits.clampLimit(limit);
    final q = ProjectRules.normalizeQuery(query);
    final rows = await _projects.listPublic(
      session,
      userId,
      namePattern: q == null ? null : '%${ProjectRules.escapeLike(q)}%',
      limit: pageSize,
      offset: PageLimits.clampOffset(offset),
    );
    return _page(session, userId, rows, pageSize);
  }

  /// Replaces a project's details.
  ///
  /// Owners may change everything; write members only name, description and
  /// genres. Turning contributions off removes pending invitations and join
  /// requests; making the project private removes pending join requests.
  ///
  /// Throws [AppException]: [ErrorCode.notFound] if not visible,
  /// [ErrorCode.forbidden] without permission, [ErrorCode.validation].
  Future<ProjectResponse> update(
    Session session,
    UuidValue userId,
    UuidValue projectId,
    UpdateProjectRequest request,
  ) async {
    final (project, access) = await _access.load(session, projectId, userId);
    if (!ProjectRules.canEditDetails(access)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'You cannot edit this project',
      );
    }
    final details = ProjectRules.validateDetails(
      name: request.name,
      description: request.description,
      genres: request.genres,
      visibility: request.visibility,
      allowContributions: request.allowContributions,
    );
    if (access != ProjectAccess.owner &&
        ProjectRules.changesOwnerSettings(project, details)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'Only the owner can change visibility and contributions',
      );
    }

    final updated = await session.db.transaction((tx) async {
      final saved = await _projects.update(
        session,
        project.copyWith(
          name: details.name,
          description: details.description,
          genres: details.genres,
          visibility: details.visibility,
          allowContributions: details.allowContributions,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
      if (!details.allowContributions) {
        await _invitations.deleteForProject(
          session,
          projectId,
          transaction: tx,
        );
      }
      if (!ProjectRules.acceptsJoinRequests(saved)) {
        await _joinRequests.deleteForProject(
          session,
          projectId,
          transaction: tx,
        );
      }
      return saved;
    });

    return updated.toResponse(
      access: access,
      memberCount: await _members.count(session, projectId),
    );
  }

  /// Deletes a project and everything attached to it (owner only).
  Future<void> delete(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final project = await _access.requireOwner(session, projectId, userId);
    await _projects.delete(session, project);
  }

  /// Builds a page from `limit + 1` [rows], resolving the caller's access,
  /// member counts and pending join requests in batch.
  Future<ProjectPageResponse> _page(
    Session session,
    UuidValue userId,
    List<Project> rows,
    int pageSize,
  ) async {
    final hasMore = rows.length > pageSize;
    final items = rows.take(pageSize).toList();
    final ids = {for (final p in items) p.id!};
    final counts = await _members.countByProject(session, ids);
    final memberships = {
      for (final m in await _members.listForUserIn(session, userId, ids))
        m.projectId: m.role,
    };
    final pending = await _joinRequests.pendingProjectIds(session, userId, ids);

    return ProjectPageResponse(
      hasMore: hasMore,
      items: [
        for (final p in items)
          p.toResponse(
            access: p.ownerId == userId
                ? ProjectAccess.owner
                : switch (memberships[p.id]) {
                    ProjectRole.write => ProjectAccess.write,
                    ProjectRole.read => ProjectAccess.read,
                    null => ProjectAccess.none,
                  },
            memberCount: counts[p.id] ?? 0,
            hasPendingJoinRequest: pending.contains(p.id),
          ),
      ],
    );
  }
}
