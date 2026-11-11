import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../data/collaboration_repository.dart';
import '../../data/project_providers.dart';
import '../../data/project_repository.dart';
import '../state/project_detail_state.dart';
import '../state/project_list_state.dart';
import 'inbox_view_model.dart';
import 'project_list_view_model.dart';

part 'project_detail_view_model.g.dart';

/// ViewModel of the project detail screen: details, members, invitations,
/// join requests, and every collaboration action on them.
@riverpod
class ProjectDetailViewModel extends _$ProjectDetailViewModel {
  ProjectRepository get _projects => ref.read(projectRepositoryProvider);
  CollaborationRepository get _collab =>
      ref.read(collaborationRepositoryProvider);

  @override
  Future<ProjectDetailState> build(UuidValue projectId) async {
    try {
      return await _load();
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  Future<ProjectDetailState> _load() async {
    final project = await _projects.getById(projectId);
    final isOwner = project.access == ProjectAccess.owner;
    final isCollaborator = project.access != ProjectAccess.none;
    final results = await Future.wait([
      if (isCollaborator) _collab.listMembers(projectId) else Future.value([]),
      if (isOwner)
        _collab.listProjectInvitations(projectId)
      else
        Future.value([]),
      if (isOwner) _collab.listJoinRequests(projectId) else Future.value([]),
    ]);
    return ProjectDetailState(
      project: project,
      members: results[0].cast<ProjectMemberResponse>(),
      invitations: results[1].cast<ProjectInvitationResponse>(),
      joinRequests: results[2].cast<JoinRequestResponse>(),
    );
  }

  /// Invites [email] with [role]. Returns null on success, or the failure
  /// (so the invite dialog can show it next to the field).
  Future<Failure?> invite(String email, ProjectRole role) =>
      _act(() => _collab.invite(projectId, email, role));

  /// Cancels a pending invitation.
  Future<Failure?> cancelInvitation(UuidValue invitationId) =>
      _act(() => _collab.cancelInvitation(invitationId));

  /// Accepts or declines a join request.
  Future<Failure?> respondToJoinRequest(
    UuidValue requestId, {
    required bool accept,
  }) => _act(() => _collab.respondToJoinRequest(requestId, accept: accept));

  /// Changes a member's role.
  Future<Failure?> updateMemberRole(UuidValue userId, ProjectRole role) =>
      _act(() => _collab.updateMemberRole(projectId, userId, role));

  /// Removes a member.
  Future<Failure?> removeMember(UuidValue userId) =>
      _act(() => _collab.removeMember(projectId, userId));

  /// Asks to join with [role].
  Future<Failure?> requestToJoin(ProjectRole role) =>
      _act(() => _collab.requestToJoin(projectId, role), refreshInbox: true);

  /// Cancels the user's pending join request for this project.
  Future<Failure?> cancelJoinRequest() => _act(() async {
    final mine = await _collab.myJoinRequests();
    final request = mine.where((r) => r.projectId == projectId).firstOrNull;
    if (request != null) await _collab.cancelJoinRequest(request.id);
    return null;
  }, refreshInbox: true);

  /// Leaves the project. Returns null on success.
  Future<Failure?> leave() =>
      _act(() => _collab.leave(projectId), reload: false);

  /// Deletes the project. Returns null on success.
  Future<Failure?> deleteProject() =>
      _act(() => _projects.delete(projectId), reload: false);

  /// Clears the displayed action error.
  void clearActionFailure() {
    final current = state.value;
    if (current?.actionFailure != null) {
      state = AsyncData(current!.copyWith(actionFailure: null));
    }
  }

  /// Runs [action], then reloads the screen (unless [reload] is false, e.g.
  /// after leaving or deleting) and the affected lists.
  Future<Failure?> _act(
    Future<Object?> Function() action, {
    bool reload = true,
    bool refreshInbox = false,
  }) async {
    final current = state.value;
    if (current == null || current.isBusy) return null;
    state = AsyncData(current.copyWith(isBusy: true, actionFailure: null));
    try {
      await action();
      ref.invalidate(projectListViewModelProvider(ProjectListKind.mine));
      ref.invalidate(projectListViewModelProvider(ProjectListKind.shared));
      ref.invalidate(projectListViewModelProvider(ProjectListKind.discover));
      if (refreshInbox) ref.invalidate(inboxViewModelProvider);
      if (reload) {
        final next = await _load();
        if (ref.mounted) state = AsyncData(next);
      } else if (ref.mounted) {
        state = AsyncData(current.copyWith(isBusy: false));
      }
      return null;
    } catch (error) {
      final failure = mapGenericError(error);
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(isBusy: false, actionFailure: failure),
        );
      }
      return failure;
    }
  }
}
