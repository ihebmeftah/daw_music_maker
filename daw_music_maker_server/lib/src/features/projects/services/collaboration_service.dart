import 'package:serverpod/serverpod.dart';

import '../../../core/security/user_directory.dart';
import '../../../core/validation/validation_rules.dart';
import '../../../generated/protocol.dart';
import '../mappers/project_mapper.dart';
import '../repositories/project_invitations_repository.dart';
import '../repositories/project_join_requests_repository.dart';
import '../repositories/projects_repository.dart';
import '../repositories/project_members_repository.dart';
import 'project_access_service.dart';
import 'project_rules.dart';

/// Members, invitations (owner → email) and join requests (user → project).
class CollaborationService {
  /// Creates the service.
  const CollaborationService();

  static const _projects = ProjectsRepository();
  static const _members = ProjectMembersRepository();
  static const _invitations = ProjectInvitationsRepository();
  static const _joinRequests = ProjectJoinRequestsRepository();
  static const _access = ProjectAccessService();
  static const _users = UserDirectory();

  // ── Members ──────────────────────────────────────────────────────────────

  /// Owner and members of a project (owner first). Only the owner and
  /// members may list them.
  Future<List<ProjectMemberResponse>> listMembers(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final (project, access) = await _access.load(session, projectId, userId);
    if (access == ProjectAccess.none) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'Only collaborators can see members',
      );
    }
    final members = await _members.listForProject(session, projectId);
    final emails = await _users.emailsOf(session, {
      project.ownerId,
      for (final m in members) m.userId,
    });
    return [
      ProjectMemberResponse(
        userId: project.ownerId,
        email: emails[project.ownerId],
        role: ProjectRole.write,
        isOwner: true,
        joinedAt: project.createdAt,
      ),
      for (final m in members) m.toResponse(email: emails[m.userId]),
    ];
  }

  /// Changes a member's role (owner only).
  Future<ProjectMemberResponse> updateMemberRole(
    Session session,
    UuidValue userId,
    UpdateMemberRoleRequest request,
  ) async {
    await _access.requireOwner(session, request.projectId, userId);
    final member = await _requireMember(
      session,
      request.projectId,
      request.userId,
    );
    final updated = await _members.update(
      session,
      member.copyWith(role: request.role, updatedAt: DateTime.now().toUtc()),
    );
    return updated.toResponse(
      email: await _users.emailOf(session, updated.userId),
    );
  }

  /// Removes a member (owner only).
  Future<void> removeMember(
    Session session,
    UuidValue userId,
    UuidValue projectId,
    UuidValue memberUserId,
  ) async {
    await _access.requireOwner(session, projectId, userId);
    final member = await _requireMember(session, projectId, memberUserId);
    await _members.delete(session, member);
  }

  /// Leaves a project the caller is a member of. Owners cannot leave
  /// ([ErrorCode.conflict]); they delete the project instead.
  Future<void> leave(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final (_, access) = await _access.load(session, projectId, userId);
    if (access == ProjectAccess.owner) {
      throw AppException(
        code: ErrorCode.conflict,
        message: 'The owner cannot leave the project',
      );
    }
    final member = await _requireMember(session, projectId, userId);
    await _members.delete(session, member);
  }

  // ── Invitations (owner → email) ──────────────────────────────────────────

  /// Invites [InviteMemberRequest.email] (owner only, contributions open).
  ///
  /// Works the same whether or not an account exists for the email, so the
  /// response reveals nothing about other users. Re-inviting the same email
  /// updates the role.
  Future<ProjectInvitationResponse> invite(
    Session session,
    UuidValue userId,
    InviteMemberRequest request,
  ) async {
    final project = await _access.requireOwner(
      session,
      request.projectId,
      userId,
    );
    _requireContributions(project);
    final email = ProjectRules.validateEmail(request.email);
    if (email == await _users.emailOf(session, userId)) {
      throw AppException(
        code: ErrorCode.validation,
        fieldErrors: {'email': 'You already own this project'},
      );
    }
    final existingUserId = await _users.userIdForEmail(session, email);
    if (existingUserId != null &&
        await _members.find(session, project.id!, existingUserId) != null) {
      throw AppException(
        code: ErrorCode.conflict,
        message: 'Already a member',
        fieldErrors: {'email': 'This person is already a member'},
      );
    }

    final existing = await _invitations.findFor(session, project.id!, email);
    final ProjectInvitation saved;
    if (existing != null) {
      saved = await _invitations.update(
        session,
        existing.copyWith(
          role: request.role,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      await _requireCapacity(session, project.id!);
      saved = await _invitations.insert(
        session,
        ProjectInvitation(
          projectId: project.id!,
          email: email,
          role: request.role,
          invitedById: userId,
        ),
      );
    }
    return saved.toResponse(projectName: project.name);
  }

  /// Pending invitations of a project (owner only).
  Future<List<ProjectInvitationResponse>> listProjectInvitations(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final project = await _access.requireOwner(session, projectId, userId);
    final rows = await _invitations.listForProject(session, projectId);
    return [for (final i in rows) i.toResponse(projectName: project.name)];
  }

  /// Cancels a pending invitation (owner of its project only).
  Future<void> cancelInvitation(
    Session session,
    UuidValue userId,
    UuidValue invitationId,
  ) async {
    final invitation = await _invitations.findById(session, invitationId);
    final project = invitation == null
        ? null
        : await _projects.findById(session, invitation.projectId);
    if (invitation == null || project?.ownerId != userId) {
      throw AppException(code: ErrorCode.notFound);
    }
    await _invitations.delete(session, invitation);
  }

  /// Pending invitations addressed to the caller's email.
  Future<List<ProjectInvitationResponse>> myInvitations(
    Session session,
    UuidValue userId,
  ) async {
    final email = await _users.emailOf(session, userId);
    if (email == null) return [];
    final rows = await _invitations.listForEmail(session, email);
    final projects = await _projects.findByIds(session, {
      for (final i in rows) i.projectId,
    });
    return [
      for (final i in rows)
        if (projects[i.projectId] case final p?)
          i.toResponse(projectName: p.name),
    ];
  }

  /// Accepts (joins with the invited role) or declines an invitation
  /// addressed to the caller.
  Future<void> respondToInvitation(
    Session session,
    UuidValue userId,
    UuidValue invitationId, {
    required bool accept,
  }) async {
    final invitation = await _invitations.findById(session, invitationId);
    final email = await _users.emailOf(session, userId);
    final project = invitation == null
        ? null
        : await _projects.findById(session, invitation.projectId);
    if (invitation == null || project == null || invitation.email != email) {
      throw AppException(code: ErrorCode.notFound);
    }

    await session.db.transaction((tx) async {
      final isMember =
          await _members.find(
            session,
            project.id!,
            userId,
            transaction: tx,
          ) !=
          null;
      if (accept && !isMember && project.ownerId != userId) {
        await _members.insert(
          session,
          ProjectMember(
            projectId: project.id!,
            userId: userId,
            role: invitation.role,
          ),
          transaction: tx,
        );
      }
      await _invitations.delete(session, invitation, transaction: tx);
    });
  }

  // ── Join requests (user → project) ───────────────────────────────────────

  /// Asks to join a public project that accepts contributions. Re-requesting
  /// updates the requested role.
  Future<JoinRequestResponse> requestToJoin(
    Session session,
    UuidValue userId,
    JoinProjectRequest request,
  ) async {
    final (project, access) = await _access.load(
      session,
      request.projectId,
      userId,
    );
    if (access != ProjectAccess.none) {
      throw AppException(
        code: ErrorCode.conflict,
        message: 'You already have access to this project',
      );
    }
    if (!ProjectRules.acceptsJoinRequests(project)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'This project does not accept join requests',
      );
    }

    final existing = await _joinRequests.findFor(session, project.id!, userId);
    final ProjectJoinRequest saved;
    if (existing != null) {
      saved = await _joinRequests.update(
        session,
        existing.copyWith(
          role: request.role,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      await _requireCapacity(session, project.id!);
      saved = await _joinRequests.insert(
        session,
        ProjectJoinRequest(
          projectId: project.id!,
          userId: userId,
          role: request.role,
        ),
      );
    }
    return saved.toResponse(
      projectName: project.name,
      email: await _users.emailOf(session, userId),
    );
  }

  /// Cancels the caller's own pending join request.
  Future<void> cancelJoinRequest(
    Session session,
    UuidValue userId,
    UuidValue requestId,
  ) async {
    final request = await _joinRequests.findById(session, requestId);
    if (request == null || request.userId != userId) {
      throw AppException(code: ErrorCode.notFound);
    }
    await _joinRequests.delete(session, request);
  }

  /// The caller's pending join requests.
  Future<List<JoinRequestResponse>> myJoinRequests(
    Session session,
    UuidValue userId,
  ) async {
    final rows = await _joinRequests.listForUser(session, userId);
    final email = await _users.emailOf(session, userId);
    final projects = await _projects.findByIds(session, {
      for (final r in rows) r.projectId,
    });
    return [
      for (final r in rows)
        if (projects[r.projectId] case final p?)
          r.toResponse(projectName: p.name, email: email),
    ];
  }

  /// Pending join requests of a project, with requester emails (owner only).
  Future<List<JoinRequestResponse>> listJoinRequests(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    final project = await _access.requireOwner(session, projectId, userId);
    final rows = await _joinRequests.listForProject(session, projectId);
    final emails = await _users.emailsOf(session, {
      for (final r in rows) r.userId,
    });
    return [
      for (final r in rows)
        r.toResponse(projectName: project.name, email: emails[r.userId]),
    ];
  }

  /// Accepts (adds the requester with the requested role) or declines a join
  /// request (owner of its project only).
  Future<void> respondToJoinRequest(
    Session session,
    UuidValue userId,
    UuidValue requestId, {
    required bool accept,
  }) async {
    final request = await _joinRequests.findById(session, requestId);
    final project = request == null
        ? null
        : await _projects.findById(session, request.projectId);
    if (request == null || project == null || project.ownerId != userId) {
      throw AppException(code: ErrorCode.notFound);
    }

    await session.db.transaction((tx) async {
      if (accept) {
        final memberCount = await _members.count(
          session,
          project.id!,
          transaction: tx,
        );
        if (memberCount >= ValidationRules.projectMembersMax) {
          throw AppException(code: ErrorCode.limitReached);
        }
        final isMember =
            await _members.find(
              session,
              project.id!,
              request.userId,
              transaction: tx,
            ) !=
            null;
        if (!isMember) {
          await _members.insert(
            session,
            ProjectMember(
              projectId: project.id!,
              userId: request.userId,
              role: request.role,
            ),
            transaction: tx,
          );
        }
      }
      await _joinRequests.delete(session, request, transaction: tx);
    });
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<ProjectMember> _requireMember(
    Session session,
    UuidValue projectId,
    UuidValue memberUserId,
  ) async {
    final member = await _members.find(session, projectId, memberUserId);
    if (member == null) throw AppException(code: ErrorCode.notFound);
    return member;
  }

  void _requireContributions(Project project) {
    if (!project.allowContributions) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'Contributions are disabled for this project',
      );
    }
  }

  /// Members + pending invitations must stay below the collaborator cap.
  Future<void> _requireCapacity(Session session, UuidValue projectId) async {
    final used =
        await _members.count(session, projectId) +
        await _invitations.count(session, projectId);
    if (used >= ValidationRules.projectMembersMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A project can have at most '
            '${ValidationRules.projectMembersMax} collaborators',
      );
    }
  }
}
