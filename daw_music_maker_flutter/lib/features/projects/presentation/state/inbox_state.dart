import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'inbox_state.freezed.dart';

/// Invitations received and join requests sent by the user.
@freezed
abstract class InboxState with _$InboxState {
  /// Creates the state.
  const factory InboxState({
    /// Invitations addressed to the user.
    @Default(<ProjectInvitationResponse>[])
    List<ProjectInvitationResponse> invitations,

    /// Join requests the user sent.
    @Default(<JoinRequestResponse>[]) List<JoinRequestResponse> joinRequests,

    /// Whether an action is in flight.
    @Default(false) bool isBusy,

    /// Error of the last action.
    Failure? actionFailure,
  }) = _InboxState;
}
