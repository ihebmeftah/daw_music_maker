import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// Members, invitations and join requests of projects.
///
/// Every method throws a `Failure` (see `core/errors/failure.dart`) on error.
abstract interface class CollaborationRepository {
  /// Owner (first) and members of a project.
  Future<List<ProjectMemberResponse>> listMembers(UuidValue projectId);

  /// Changes a member's role (owner only).
  Future<ProjectMemberResponse> updateMemberRole(
    UuidValue projectId,
    UuidValue userId,
    ProjectRole role,
  );

  /// Removes a member (owner only).
  Future<void> removeMember(UuidValue projectId, UuidValue userId);

  /// Leaves a project the current user is a member of.
  Future<void> leave(UuidValue projectId);

  /// Invites [email] with [role] (owner only, contributions open).
  Future<ProjectInvitationResponse> invite(
    UuidValue projectId,
    String email,
    ProjectRole role,
  );

  /// Pending invitations of a project (owner only).
  Future<List<ProjectInvitationResponse>> listProjectInvitations(
    UuidValue projectId,
  );

  /// Cancels a pending invitation (owner only).
  Future<void> cancelInvitation(UuidValue invitationId);

  /// Invitations addressed to the current user.
  Future<List<ProjectInvitationResponse>> myInvitations();

  /// Accepts or declines an invitation.
  Future<void> respondToInvitation(
    UuidValue invitationId, {
    required bool accept,
  });

  /// Asks to join a public project.
  Future<JoinRequestResponse> requestToJoin(
    UuidValue projectId,
    ProjectRole role,
  );

  /// Cancels the current user's join request.
  Future<void> cancelJoinRequest(UuidValue requestId);

  /// The current user's pending join requests.
  Future<List<JoinRequestResponse>> myJoinRequests();

  /// Pending join requests of a project (owner only).
  Future<List<JoinRequestResponse>> listJoinRequests(UuidValue projectId);

  /// Accepts or declines a join request (owner only).
  Future<void> respondToJoinRequest(
    UuidValue requestId, {
    required bool accept,
  });
}
