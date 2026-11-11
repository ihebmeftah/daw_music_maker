import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'project_detail_state.freezed.dart';

/// Everything the project detail screen shows.
@freezed
abstract class ProjectDetailState with _$ProjectDetailState {
  /// Creates the state.
  const factory ProjectDetailState({
    /// The project.
    required ProjectResponse project,

    /// Owner and members (empty for non-member viewers).
    @Default(<ProjectMemberResponse>[]) List<ProjectMemberResponse> members,

    /// Pending invitations (owner only).
    @Default(<ProjectInvitationResponse>[])
    List<ProjectInvitationResponse> invitations,

    /// Pending join requests (owner only).
    @Default(<JoinRequestResponse>[]) List<JoinRequestResponse> joinRequests,

    /// Whether an action is in flight.
    @Default(false) bool isBusy,

    /// Error of the last action.
    Failure? actionFailure,
  }) = _ProjectDetailState;

  const ProjectDetailState._();

  /// Whether the user owns the project.
  bool get isOwner => project.access == ProjectAccess.owner;

  /// Whether the user is a (non-owner) member.
  bool get isMember =>
      project.access == ProjectAccess.read ||
      project.access == ProjectAccess.write;

  /// Whether the user may edit name, description and genres.
  bool get canEdit =>
      project.access == ProjectAccess.owner ||
      project.access == ProjectAccess.write;

  /// Whether the user can ask to join.
  bool get canRequestToJoin =>
      project.access == ProjectAccess.none &&
      project.visibility == ProjectVisibility.public &&
      project.allowContributions;
}
