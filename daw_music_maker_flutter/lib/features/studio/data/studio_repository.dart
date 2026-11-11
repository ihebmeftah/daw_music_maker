import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// Data the studio needs: the project and its tempo.
///
/// Every method throws a `Failure` (see `core/errors/failure.dart`) on error.
abstract interface class StudioRepository {
  /// Loads the project opened in the studio.
  Future<ProjectResponse> loadProject(UuidValue projectId);

  /// Saves the project's tempo (owner or write member).
  Future<ProjectResponse> saveTempo(UuidValue projectId, double bpm);
}
