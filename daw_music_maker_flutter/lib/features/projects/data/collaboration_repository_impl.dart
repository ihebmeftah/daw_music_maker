import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/error_mapper.dart';
import 'collaboration_repository.dart';

/// [CollaborationRepository] backed by the `projectCollaboration` endpoint.
@LazySingleton(as: CollaborationRepository)
class CollaborationRepositoryImpl implements CollaborationRepository {
  /// Creates the repository.
  CollaborationRepositoryImpl(this._endpoint);

  final EndpointProjectCollaboration _endpoint;

  @override
  Future<List<ProjectMemberResponse>> listMembers(UuidValue projectId) =>
      _guard(() => _endpoint.listMembers(projectId));

  @override
  Future<ProjectMemberResponse> updateMemberRole(
    UuidValue projectId,
    UuidValue userId,
    ProjectRole role,
  ) => _guard(
    () => _endpoint.updateMemberRole(
      UpdateMemberRoleRequest(projectId: projectId, userId: userId, role: role),
    ),
  );

  @override
  Future<void> removeMember(UuidValue projectId, UuidValue userId) =>
      _guard(() => _endpoint.removeMember(projectId, userId));

  @override
  Future<void> leave(UuidValue projectId) =>
      _guard(() => _endpoint.leave(projectId));

  @override
  Future<ProjectInvitationResponse> invite(
    UuidValue projectId,
    String email,
    ProjectRole role,
  ) => _guard(
    () => _endpoint.invite(
      InviteMemberRequest(
        projectId: projectId,
        email: email.trim().toLowerCase(),
        role: role,
      ),
    ),
  );

  @override
  Future<List<ProjectInvitationResponse>> listProjectInvitations(
    UuidValue projectId,
  ) => _guard(() => _endpoint.listProjectInvitations(projectId));

  @override
  Future<void> cancelInvitation(UuidValue invitationId) =>
      _guard(() => _endpoint.cancelInvitation(invitationId));

  @override
  Future<List<ProjectInvitationResponse>> myInvitations() =>
      _guard(_endpoint.myInvitations);

  @override
  Future<void> respondToInvitation(
    UuidValue invitationId, {
    required bool accept,
  }) => _guard(() => _endpoint.respondToInvitation(invitationId, accept));

  @override
  Future<JoinRequestResponse> requestToJoin(
    UuidValue projectId,
    ProjectRole role,
  ) => _guard(
    () => _endpoint.requestToJoin(
      JoinProjectRequest(projectId: projectId, role: role),
    ),
  );

  @override
  Future<void> cancelJoinRequest(UuidValue requestId) =>
      _guard(() => _endpoint.cancelJoinRequest(requestId));

  @override
  Future<List<JoinRequestResponse>> myJoinRequests() =>
      _guard(_endpoint.myJoinRequests);

  @override
  Future<List<JoinRequestResponse>> listJoinRequests(UuidValue projectId) =>
      _guard(() => _endpoint.listJoinRequests(projectId));

  @override
  Future<void> respondToJoinRequest(
    UuidValue requestId, {
    required bool accept,
  }) => _guard(() => _endpoint.respondToJoinRequest(requestId, accept));

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw mapGenericError(error);
    }
  }
}
