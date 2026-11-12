import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [Pattern] rows. No business rules.
///
/// Pluralized because Serverpod generates `PatternRepository` for the ORM.
class PatternsRepository {
  /// Creates the repository.
  const PatternsRepository();

  /// Finds a pattern by id (no access check — callers must check).
  Future<Pattern?> findById(Session session, UuidValue id) =>
      Pattern.db.findById(session, id);

  /// Patterns of [projectId] in display order.
  Future<List<Pattern>> listForProject(
    Session session,
    UuidValue projectId, {
    Transaction? transaction,
  }) => Pattern.db.find(
    session,
    where: (t) => t.projectId.equals(projectId),
    orderBy: (t) => t.position,
    transaction: transaction,
  );

  /// Number of patterns of [projectId].
  Future<int> count(
    Session session,
    UuidValue projectId, {
    Transaction? transaction,
  }) => Pattern.db.count(
    session,
    where: (t) => t.projectId.equals(projectId),
    transaction: transaction,
  );

  /// Inserts [pattern].
  Future<Pattern> insert(
    Session session,
    Pattern pattern, {
    Transaction? transaction,
  }) => Pattern.db.insertRow(session, pattern, transaction: transaction);

  /// Updates [pattern].
  Future<Pattern> update(Session session, Pattern pattern) =>
      Pattern.db.updateRow(session, pattern);

  /// Deletes [pattern].
  Future<void> delete(
    Session session,
    Pattern pattern, {
    Transaction? transaction,
  }) => Pattern.db.deleteRow(session, pattern, transaction: transaction);
}
