import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [PatternNote] rows. No business rules.
class PatternNotesRepository {
  /// Creates the repository.
  const PatternNotesRepository();

  /// Notes of [patternId], ordered by time then pitch.
  Future<List<PatternNote>> listForPattern(
    Session session,
    UuidValue patternId, {
    Transaction? transaction,
  }) => PatternNote.db.find(
    session,
    where: (t) => t.patternId.equals(patternId),
    orderByList: (t) => [t.tick.asc(), t.pitch.asc()],
    transaction: transaction,
  );

  /// Replaces all notes of [patternId] with [notes] (inside [transaction]).
  Future<List<PatternNote>> replaceAll(
    Session session,
    UuidValue patternId,
    List<PatternNote> notes, {
    required Transaction transaction,
  }) async {
    await PatternNote.db.deleteWhere(
      session,
      where: (t) => t.patternId.equals(patternId),
      transaction: transaction,
    );
    if (notes.isEmpty) return [];
    return PatternNote.db.insert(session, notes, transaction: transaction);
  }

  /// Deletes notes of [patternId] starting at or after [tick].
  Future<void> deleteFrom(
    Session session,
    UuidValue patternId,
    int tick, {
    Transaction? transaction,
  }) => PatternNote.db.deleteWhere(
    session,
    where: (t) => t.patternId.equals(patternId) & (t.tick >= tick),
    transaction: transaction,
  );
}
