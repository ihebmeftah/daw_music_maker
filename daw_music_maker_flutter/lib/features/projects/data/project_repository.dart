import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// Project CRUD and listing.
///
/// Every method throws a `Failure` (see `core/errors/failure.dart`) on error.
abstract interface class ProjectRepository {
  /// Creates a project owned by the current user.
  Future<ProjectResponse> create(CreateProjectRequest request);

  /// Loads a project visible to the current user.
  Future<ProjectResponse> getById(UuidValue id);

  /// Projects owned by the current user.
  Future<ProjectPageResponse> listMine({int? limit, int? offset});

  /// Projects the current user collaborates on.
  Future<ProjectPageResponse> listShared({int? limit, int? offset});

  /// Public projects of other users, optionally filtered by name.
  Future<ProjectPageResponse> discover({
    String? query,
    int? limit,
    int? offset,
  });

  /// Replaces a project's details.
  Future<ProjectResponse> update(UuidValue id, UpdateProjectRequest request);

  /// Deletes a project (owner only).
  Future<void> delete(UuidValue id);
}
