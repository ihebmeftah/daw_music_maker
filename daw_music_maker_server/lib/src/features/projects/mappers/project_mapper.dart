import '../../../generated/protocol.dart';

/// Entity → response mapping for projects.
extension ProjectMapper on Project {
  /// Maps to a [ProjectResponse] for a caller with [access].
  ProjectResponse toResponse({
    required ProjectAccess access,
    required int memberCount,
    bool hasPendingJoinRequest = false,
  }) => ProjectResponse(
    id: id!,
    ownerId: ownerId,
    name: name,
    description: description,
    genres: List.of(genres),
    visibility: visibility,
    allowContributions: allowContributions,
    access: access,
    memberCount: memberCount,
    hasPendingJoinRequest: hasPendingJoinRequest,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// Entity → response mapping for members.
extension ProjectMemberMapper on ProjectMember {
  /// Maps to a [ProjectMemberResponse].
  ProjectMemberResponse toResponse({String? email}) => ProjectMemberResponse(
    userId: userId,
    email: email,
    role: role,
    isOwner: false,
    joinedAt: createdAt,
  );
}

/// Entity → response mapping for invitations.
extension ProjectInvitationMapper on ProjectInvitation {
  /// Maps to a [ProjectInvitationResponse] for the project [projectName].
  ProjectInvitationResponse toResponse({required String projectName}) =>
      ProjectInvitationResponse(
        id: id!,
        projectId: projectId,
        projectName: projectName,
        email: email,
        role: role,
        createdAt: createdAt,
      );
}

/// Entity → response mapping for join requests.
extension ProjectJoinRequestMapper on ProjectJoinRequest {
  /// Maps to a [JoinRequestResponse] for the project [projectName].
  JoinRequestResponse toResponse({
    required String projectName,
    String? email,
  }) => JoinRequestResponse(
    id: id!,
    projectId: projectId,
    projectName: projectName,
    userId: userId,
    email: email,
    role: role,
    createdAt: createdAt,
  );
}
