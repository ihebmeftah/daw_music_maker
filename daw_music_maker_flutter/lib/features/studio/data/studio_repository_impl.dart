import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/error_mapper.dart';
import 'studio_repository.dart';

/// [StudioRepository] backed by the server's `project` endpoint.
@LazySingleton(as: StudioRepository)
class StudioRepositoryImpl implements StudioRepository {
  /// Creates the repository.
  StudioRepositoryImpl(this._endpoint);

  final EndpointProject _endpoint;

  @override
  Future<ProjectResponse> loadProject(UuidValue projectId) =>
      _guard(() => _endpoint.getById(projectId));

  @override
  Future<ProjectResponse> saveTempo(UuidValue projectId, double bpm) => _guard(
    () => _endpoint.updateTempo(
      projectId,
      UpdateProjectTempoRequest(bpm: bpm),
    ),
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw mapGenericError(error);
    }
  }
}
