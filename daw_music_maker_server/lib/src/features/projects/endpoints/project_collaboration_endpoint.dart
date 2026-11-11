import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/collaboration_service.dart';

/// Members, invitations and join requests (`client.projectCollaboration`).
///
/// Requires a signed-in user. Throws [AppException]: [ErrorCode.notFound]
/// for projects/invitations/requests the caller cannot see,
/// [ErrorCode.forbidden] when the caller's role does not allow the action or
/// contributions are disabled, [ErrorCode.conflict] (already a member, owner
/// leaving), [ErrorCode.limitReached] (collaborator cap) and
/// [ErrorCode.validation].
class ProjectCollaborationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = CollaborationService();

  /// Owner and members of a project, owner first (owner and members only).
  Future<List<ProjectMemberResponse>> listMembers(
    Session session,
    UuidValue projectId,
  ) => _service.listMembers(session, session.requireUserId, projectId);

  /// Changes a member's role (owner only).
  Future<ProjectMemberResponse> updateMemberRole(
    Session session,
    UpdateMemberRoleRequest request,
  ) => _service.updateMemberRole(session, session.requireUserId, request);

  /// Removes a member (owner only).
  Future<void> removeMember(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) => _service.removeMember(session, session.requireUserId, projectId, userId);

  /// Leaves a project the caller is a member of.
  Future<void> leave(Session session, UuidValue projectId) =>
      _service.leave(session, session.requireUserId, projectId);

  /// Invites an email address with a role (owner only, contributions open).
  /// Behaves identically whether or not the email has an account.
  Future<ProjectInvitationResponse> invite(
    Session session,
    InviteMemberRequest request,
  ) => _service.invite(session, session.requireUserId, request);

  /// Pending invitations of a project (owner only).
  Future<List<ProjectInvitationResponse>> listProjectInvitations(
    Session session,
    UuidValue projectId,
  ) => _service.listProjectInvitations(
    session,
    session.requireUserId,
    projectId,
  );

  /// Cancels a pending invitation (owner only).
  Future<void> cancelInvitation(Session session, UuidValue invitationId) =>
      _service.cancelInvitation(session, session.requireUserId, invitationId);

  /// Pending invitations addressed to the caller's email.
  Future<List<ProjectInvitationResponse>> myInvitations(Session session) =>
      _service.myInvitations(session, session.requireUserId);

  /// Accepts or declines an invitation addressed to the caller.
  Future<void> respondToInvitation(
    Session session,
    UuidValue invitationId,
    bool accept,
  ) => _service.respondToInvitation(
    session,
    session.requireUserId,
    invitationId,
    accept: accept,
  );

  /// Asks to join a public project that accepts contributions.
  Future<JoinRequestResponse> requestToJoin(
    Session session,
    JoinProjectRequest request,
  ) => _service.requestToJoin(session, session.requireUserId, request);

  /// Cancels the caller's own pending join request.
  Future<void> cancelJoinRequest(Session session, UuidValue requestId) =>
      _service.cancelJoinRequest(session, session.requireUserId, requestId);

  /// The caller's pending join requests.
  Future<List<JoinRequestResponse>> myJoinRequests(Session session) =>
      _service.myJoinRequests(session, session.requireUserId);

  /// Pending join requests of a project with requester emails (owner only).
  Future<List<JoinRequestResponse>> listJoinRequests(
    Session session,
    UuidValue projectId,
  ) => _service.listJoinRequests(session, session.requireUserId, projectId);

  /// Accepts or declines a join request (owner only).
  Future<void> respondToJoinRequest(
    Session session,
    UuidValue requestId,
    bool accept,
  ) => _service.respondToJoinRequest(
    session,
    session.requireUserId,
    requestId,
    accept: accept,
  );
}
