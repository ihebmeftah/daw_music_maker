import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/collaboration_repository.dart';
import '../../data/project_providers.dart';
import '../state/inbox_state.dart';
import '../state/project_list_state.dart';
import 'project_list_view_model.dart';

part 'inbox_view_model.g.dart';

/// ViewModel of the inbox: invitations received and join requests sent.
@riverpod
class InboxViewModel extends _$InboxViewModel {
  CollaborationRepository get _collab =>
      ref.read(collaborationRepositoryProvider);

  @override
  Future<InboxState> build() async {
    try {
      return await _load();
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  Future<InboxState> _load() async {
    final (invitations, requests) = await (
      _collab.myInvitations(),
      _collab.myJoinRequests(),
    ).wait;
    return InboxState(invitations: invitations, joinRequests: requests);
  }

  /// Accepts or declines an invitation. Accepting adds the project to the
  /// "shared with me" list.
  Future<void> respondToInvitation(
    UuidValue invitationId, {
    required bool accept,
  }) => _act(() async {
    await _collab.respondToInvitation(invitationId, accept: accept);
    if (accept) {
      ref.invalidate(projectListViewModelProvider(ProjectListKind.shared));
    }
  });

  /// Cancels a join request the user sent.
  Future<void> cancelJoinRequest(UuidValue requestId) => _act(() async {
    await _collab.cancelJoinRequest(requestId);
    ref.invalidate(projectListViewModelProvider(ProjectListKind.discover));
  });

  /// Clears the displayed action error.
  void clearActionFailure() {
    final current = state.value;
    if (current?.actionFailure != null) {
      state = AsyncData(current!.copyWith(actionFailure: null));
    }
  }

  Future<void> _act(Future<void> Function() action) async {
    final current = state.value;
    if (current == null || current.isBusy) return;
    state = AsyncData(current.copyWith(isBusy: true, actionFailure: null));
    try {
      await action();
      final next = await _load();
      if (ref.mounted) state = AsyncData(next);
    } catch (error) {
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(
            isBusy: false,
            actionFailure: mapGenericError(error),
          ),
        );
      }
    }
  }
}
