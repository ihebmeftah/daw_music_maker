import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Database access for [Sample] rows. No business rules.
///
/// Pluralized because Serverpod generates `SampleRepository` for the ORM.
class SamplesRepository {
  /// Creates the repository.
  const SamplesRepository();

  /// Finds a sample by id (no access check — callers must check).
  Future<Sample?> findById(Session session, UuidValue id) =>
      Sample.db.findById(session, id);

  /// Finds the sample stored at [path].
  Future<Sample?> findByPath(Session session, String path) =>
      Sample.db.findFirstRow(session, where: (t) => t.storagePath.equals(path));

  /// Samples of [projectId], newest first.
  Future<List<Sample>> listForProject(Session session, UuidValue projectId) =>
      Sample.db.find(
        session,
        where: (t) => t.projectId.equals(projectId),
        orderBy: (t) => t.createdAt.desc(),
      );

  /// Number of samples of [projectId].
  Future<int> count(Session session, UuidValue projectId) =>
      Sample.db.count(session, where: (t) => t.projectId.equals(projectId));

  /// Inserts [sample].
  Future<Sample> insert(Session session, Sample sample) =>
      Sample.db.insertRow(session, sample);

  /// Deletes [sample] (channels and clips using it cascade).
  Future<void> delete(Session session, Sample sample) =>
      Sample.db.deleteRow(session, sample);
}
