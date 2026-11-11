import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../repositories/project_members_repository.dart';
import '../repositories/projects_repository.dart';

/// Resolves what the caller may do with a project.
class ProjectAccessService {
  /// Creates the service.
  const ProjectAccessService();

  static const _projects = ProjectsRepository();
  static const _members = ProjectMembersRepository();

  /// Loads [projectId] with the caller's [ProjectAccess].
  ///
  /// Throws [AppException] with [ErrorCode.notFound] when the project does not
  /// exist or is private and the caller is neither owner nor member.
  Future<(Project, ProjectAccess)> load(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) async {
    final project = await _projects.findById(session, projectId);
    if (project == null) throw AppException(code: ErrorCode.notFound);
    if (project.ownerId == userId) return (project, ProjectAccess.owner);

    final member = await _members.find(session, projectId, userId);
    if (member != null) {
      return (
        project,
        member.role == ProjectRole.write
            ? ProjectAccess.write
            : ProjectAccess.read,
      );
    }
    if (project.visibility == ProjectVisibility.public) {
      return (project, ProjectAccess.none);
    }
    throw AppException(code: ErrorCode.notFound);
  }

  /// Loads [projectId] and requires the caller to own it.
  ///
  /// Throws [AppException] with [ErrorCode.notFound] when not visible, or
  /// [ErrorCode.forbidden] when visible but not owned.
  Future<Project> requireOwner(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) async {
    final (project, access) = await load(session, projectId, userId);
    if (access != ProjectAccess.owner) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'Only the owner can do this',
      );
    }
    return project;
  }
}
