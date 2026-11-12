import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/channel_service.dart';

/// The channel rack of a project (`client.channel`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation],
/// [ErrorCode.limitReached] (32 channels).
class ChannelEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = ChannelService();

  /// Channels of a project, in rack order.
  Future<List<ChannelResponse>> list(Session session, UuidValue projectId) =>
      _service.list(session, session.requireUserId, projectId);

  /// Adds a channel playing a built-in sample.
  Future<ChannelResponse> create(
    Session session,
    CreateChannelRequest request,
  ) => _service.create(session, session.requireUserId, request);

  /// Renames a channel and sets volume / mute.
  Future<ChannelResponse> update(
    Session session,
    UuidValue channelId,
    UpdateChannelRequest request,
  ) => _service.update(session, session.requireUserId, channelId, request);

  /// Chops a channel's region into 2/4/8/16 slices, one new channel each.
  Future<List<ChannelResponse>> chop(
    Session session,
    UuidValue channelId,
    ChopChannelRequest request,
  ) => _service.chop(session, session.requireUserId, channelId, request);

  /// Deletes a channel and its notes.
  Future<void> delete(Session session, UuidValue channelId) =>
      _service.delete(session, session.requireUserId, channelId);
}
