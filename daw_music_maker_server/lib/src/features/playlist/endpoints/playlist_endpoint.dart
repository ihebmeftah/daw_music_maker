import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/playlist_service.dart';

/// The playlist (song arrangement) of a project (`client.playlist`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// saving needs owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation]
/// (unknown pattern, out of range, overlapping clips),
/// [ErrorCode.limitReached] (2048 clips).
class PlaylistEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = PlaylistService();

  /// Clips of the project's playlist, ordered by track then start bar.
  Future<List<ClipResponse>> list(Session session, UuidValue projectId) =>
      _service.list(session, session.requireUserId, projectId);

  /// Replaces the whole playlist.
  Future<List<ClipResponse>> save(
    Session session,
    UuidValue projectId,
    SavePlaylistRequest request,
  ) => _service.save(session, session.requireUserId, projectId, request);
}
