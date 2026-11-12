import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [PlaylistClip] rows. No business rules.
class PlaylistClipsRepository {
  /// Creates the repository.
  const PlaylistClipsRepository();

  /// Clips of [projectId], ordered by track then start.
  Future<List<PlaylistClip>> listForProject(
    Session session,
    UuidValue projectId,
  ) => PlaylistClip.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderByList: (t) => [t.track.asc(), t.startBar.asc()],
  );

  /// Replaces all clips of [projectId] (inside [transaction]).
  Future<List<PlaylistClip>> replaceAll(
    Session session,
    UuidValue projectId,
    List<PlaylistClip> clips, {
    required Transaction transaction,
  }) async {
    await PlaylistClip.db.deleteWhere(
      session,
      where: (t) => t.projectId.equals(projectId),
      transaction: transaction,
    );
    if (clips.isEmpty) return [];
    return PlaylistClip.db.insert(session, clips, transaction: transaction);
  }
}
