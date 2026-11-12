import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/pattern_service.dart';

/// Patterns of a project (`client.pattern`).
///
/// Requires a signed-in user. Listing needs the project to be visible;
/// changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound] (project/pattern not visible), [ErrorCode.forbidden]
/// (read member or visitor), [ErrorCode.validation], [ErrorCode.conflict]
/// (deleting the last pattern), [ErrorCode.limitReached] (99 patterns).
class PatternEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = PatternService();

  /// Patterns of a project, in order.
  Future<List<PatternResponse>> list(Session session, UuidValue projectId) =>
      _service.list(session, session.requireUserId, projectId);

  /// Adds a pattern (defaults: "Pattern N", next color, 4 bars).
  Future<PatternResponse> create(
    Session session,
    CreatePatternRequest request,
  ) => _service.create(session, session.requireUserId, request);

  /// Renames / recolors / resizes a pattern.
  Future<PatternResponse> update(
    Session session,
    UuidValue patternId,
    UpdatePatternRequest request,
  ) => _service.update(session, session.requireUserId, patternId, request);

  /// Duplicates a pattern at the end of the list.
  Future<PatternResponse> clone(Session session, UuidValue patternId) =>
      _service.clone(session, session.requireUserId, patternId);

  /// Notes of a pattern (anyone who can see the project).
  Future<List<NoteResponse>> listNotes(Session session, UuidValue patternId) =>
      _service.listNotes(session, session.requireUserId, patternId);

  /// Replaces all notes of a pattern (owner or write member). Notes must
  /// fit in the pattern, use the project's channels, pitch 0–127 and
  /// velocity 1–127; at most 4096 notes.
  Future<List<NoteResponse>> saveNotes(
    Session session,
    UuidValue patternId,
    SavePatternNotesRequest request,
  ) => _service.saveNotes(session, session.requireUserId, patternId, request);

  /// Deletes a pattern (never the last one).
  Future<void> delete(Session session, UuidValue patternId) =>
      _service.delete(session, session.requireUserId, patternId);
}
