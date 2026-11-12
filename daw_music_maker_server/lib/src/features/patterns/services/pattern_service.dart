import 'package:serverpod/serverpod.dart';

import '../../../core/validation/validation_rules.dart';
import '../../../generated/protocol.dart';
import '../../projects/services/project_access_service.dart';
import '../../projects/services/project_rules.dart';
import '../../channels/repositories/channels_repository.dart';
import '../mappers/note_mapper.dart';
import '../mappers/pattern_mapper.dart';
import '../repositories/pattern_notes_repository.dart';
import '../repositories/patterns_repository.dart';
import 'pattern_rules.dart';

/// Pattern management. Anyone who can see a project can list its patterns;
/// owners and write members can change them.
class PatternService {
  /// Creates the service.
  const PatternService();

  static const _patterns = PatternsRepository();
  static const _notes = PatternNotesRepository();
  static const _channels = ChannelsRepository();
  static const _access = ProjectAccessService();

  /// Patterns of a visible project, in order.
  Future<List<PatternResponse>> list(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    await _access.load(session, projectId, userId);
    final rows = await _patterns.listForProject(session, projectId);
    return [for (final p in rows) p.toResponse()];
  }

  /// Adds a pattern at the end. Missing settings get defaults
  /// ("Pattern N", next palette color, 4 bars).
  ///
  /// Throws [AppException]: [ErrorCode.limitReached] past the per-project cap.
  Future<PatternResponse> create(
    Session session,
    UuidValue userId,
    CreatePatternRequest request,
  ) async {
    await _requireEditor(session, request.projectId, userId);
    final existing = await _patterns.listForProject(
      session,
      request.projectId,
    );
    _requireCapacity(existing.length);
    final settings = PatternRules.validate(
      name: request.name ?? PatternRules.defaultName(existing),
      colorIndex: request.colorIndex ?? PatternRules.defaultColor(existing),
      lengthBars: request.lengthBars ?? ValidationRules.patternLengthDefault,
    );
    final saved = await _patterns.insert(
      session,
      Pattern(
        projectId: request.projectId,
        name: settings.name,
        colorIndex: settings.colorIndex,
        lengthBars: settings.lengthBars,
        position: PatternRules.nextPosition(existing),
      ),
    );
    return saved.toResponse();
  }

  /// Replaces a pattern's name, color and length.
  Future<PatternResponse> update(
    Session session,
    UuidValue userId,
    UuidValue patternId,
    UpdatePatternRequest request,
  ) async {
    final pattern = await _requirePattern(session, patternId, userId);
    final settings = PatternRules.validate(
      name: request.name,
      colorIndex: request.colorIndex,
      lengthBars: request.lengthBars,
    );
    final saved = await _patterns.update(
      session,
      pattern.copyWith(
        name: settings.name,
        colorIndex: settings.colorIndex,
        lengthBars: settings.lengthBars,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    if (settings.lengthBars < pattern.lengthBars) {
      // Shortening drops the notes that no longer fit.
      await _notes.deleteFrom(
        session,
        pattern.id!,
        PatternRules.lengthTicks(settings.lengthBars),
      );
    }
    return saved.toResponse();
  }

  /// Duplicates a pattern (named `<name> (copy)`) at the end of the list.
  Future<PatternResponse> clone(
    Session session,
    UuidValue userId,
    UuidValue patternId,
  ) async {
    final source = await _requirePattern(session, patternId, userId);
    final existing = await _patterns.listForProject(session, source.projectId);
    _requireCapacity(existing.length);
    final saved = await session.db.transaction((tx) async {
      final copy = await _patterns.insert(
        session,
        Pattern(
          projectId: source.projectId,
          name: PatternRules.cloneName(source.name),
          colorIndex: source.colorIndex,
          lengthBars: source.lengthBars,
          position: PatternRules.nextPosition(existing),
        ),
        transaction: tx,
      );
      final notes = await _notes.listForPattern(
        session,
        source.id!,
        transaction: tx,
      );
      await _notes.replaceAll(session, copy.id!, [
        for (final n in notes) n.copyWith(id: null, patternId: copy.id!),
      ], transaction: tx);
      return copy;
    });
    return saved.toResponse();
  }

  /// Deletes a pattern. A project always keeps at least one pattern.
  ///
  /// Throws [AppException] with [ErrorCode.conflict] for the last pattern.
  Future<void> delete(
    Session session,
    UuidValue userId,
    UuidValue patternId,
  ) async {
    final pattern = await _requirePattern(session, patternId, userId);
    await session.db.transaction((tx) async {
      final count = await _patterns.count(
        session,
        pattern.projectId,
        transaction: tx,
      );
      if (count <= 1) {
        throw AppException(
          code: ErrorCode.conflict,
          message: 'A project needs at least one pattern',
        );
      }
      await _patterns.delete(session, pattern, transaction: tx);
    });
  }

  /// Notes of a pattern of a visible project.
  Future<List<NoteResponse>> listNotes(
    Session session,
    UuidValue userId,
    UuidValue patternId,
  ) async {
    final pattern = await _patterns.findById(session, patternId);
    if (pattern == null) throw AppException(code: ErrorCode.notFound);
    await _access.load(session, pattern.projectId, userId);
    final rows = await _notes.listForPattern(session, patternId);
    return [for (final n in rows) n.toResponse()];
  }

  /// Replaces all notes of a pattern (owner or write member).
  Future<List<NoteResponse>> saveNotes(
    Session session,
    UuidValue userId,
    UuidValue patternId,
    SavePatternNotesRequest request,
  ) async {
    final pattern = await _requirePattern(session, patternId, userId);
    final channelIds = await _channels.idsForProject(
      session,
      pattern.projectId,
    );
    PatternRules.validateNotes(
      request.notes,
      patternTicks: PatternRules.lengthTicks(pattern.lengthBars),
      channelIds: channelIds,
    );
    final saved = await session.db.transaction(
      (tx) => _notes.replaceAll(session, patternId, [
        for (final n in request.notes)
          PatternNote(
            patternId: patternId,
            channelId: n.channelId,
            tick: n.tick,
            lengthTicks: n.lengthTicks,
            pitch: n.pitch,
            velocity: n.velocity,
          ),
      ], transaction: tx),
    );
    return [for (final n in saved) n.toResponse()];
  }

  /// Inserts the first pattern of a new project (inside its transaction).
  Future<void> createDefault(
    Session session,
    UuidValue projectId, {
    required Transaction transaction,
  }) async {
    await _patterns.insert(
      session,
      Pattern(
        projectId: projectId,
        name: 'Pattern 1',
        colorIndex: 0,
        lengthBars: ValidationRules.patternLengthDefault,
        position: 0,
      ),
      transaction: transaction,
    );
  }

  /// Loads a pattern and requires edit access to its project. Patterns of
  /// projects the caller cannot see are reported as [ErrorCode.notFound].
  Future<Pattern> _requirePattern(
    Session session,
    UuidValue patternId,
    UuidValue userId,
  ) async {
    final pattern = await _patterns.findById(session, patternId);
    if (pattern == null) throw AppException(code: ErrorCode.notFound);
    await _requireEditor(session, pattern.projectId, userId);
    return pattern;
  }

  Future<void> _requireEditor(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) async {
    final (_, access) = await _access.load(session, projectId, userId);
    if (!ProjectRules.canEditDetails(access)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'You cannot change the patterns of this project',
      );
    }
  }

  void _requireCapacity(int count) {
    if (count >= ValidationRules.patternsMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A project can have at most ${ValidationRules.patternsMax} '
            'patterns',
      );
    }
  }
}
