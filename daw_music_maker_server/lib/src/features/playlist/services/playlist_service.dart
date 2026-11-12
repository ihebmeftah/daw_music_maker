import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../patterns/repositories/patterns_repository.dart';
import '../../samples/repositories/samples_repository.dart';
import '../../projects/services/project_access_service.dart';
import '../../projects/services/project_rules.dart';
import '../mappers/clip_mapper.dart';
import '../repositories/playlist_repository.dart';
import 'playlist_rules.dart';

/// The song arrangement of a project.
class PlaylistService {
  /// Creates the service.
  const PlaylistService();

  static const _clips = PlaylistClipsRepository();
  static const _patterns = PatternsRepository();
  static const _samples = SamplesRepository();
  static const _access = ProjectAccessService();

  /// Clips of a visible project.
  Future<List<ClipResponse>> list(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    await _access.load(session, projectId, userId);
    final rows = await _clips.listForProject(session, projectId);
    return [for (final c in rows) c.toResponse()];
  }

  /// Replaces the playlist (owner or write member).
  Future<List<ClipResponse>> save(
    Session session,
    UuidValue userId,
    UuidValue projectId,
    SavePlaylistRequest request,
  ) async {
    final (_, access) = await _access.load(session, projectId, userId);
    if (!ProjectRules.canEditDetails(access)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'You cannot change the playlist of this project',
      );
    }
    final patterns = await _patterns.listForProject(session, projectId);
    final samples = await _samples.listForProject(session, projectId);
    PlaylistRules.validate(
      request.clips,
      patternLengths: {for (final p in patterns) p.id!: p.lengthBars},
      sampleIds: {for (final s in samples) s.id!},
    );
    final saved = await session.db.transaction(
      (tx) => _clips.replaceAll(session, projectId, [
        for (final c in request.clips)
          PlaylistClip(
            projectId: projectId,
            patternId: c.patternId,
            sampleId: c.sampleId,
            lengthBars: c.sampleId == null ? null : c.lengthBars,
            track: c.track,
            startBar: c.startBar,
          ),
      ], transaction: tx),
    );
    return [for (final c in saved) c.toResponse()];
  }
}
