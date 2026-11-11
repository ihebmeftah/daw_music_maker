import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/error_mapper.dart';
import 'project_repository.dart';

/// [ProjectRepository] backed by the server's `project` endpoint.
@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  /// Creates the repository.
  ProjectRepositoryImpl(this._endpoint);

  final EndpointProject _endpoint;

  @override
  Future<ProjectResponse> create(CreateProjectRequest request) =>
      _guard(() => _endpoint.create(request));

  @override
  Future<ProjectResponse> getById(UuidValue id) =>
      _guard(() => _endpoint.getById(id));

  @override
  Future<ProjectPageResponse> listMine({int? limit, int? offset}) =>
      _guard(() => _endpoint.listMine(limit: limit, offset: offset));

  @override
  Future<ProjectPageResponse> listShared({int? limit, int? offset}) =>
      _guard(() => _endpoint.listShared(limit: limit, offset: offset));

  @override
  Future<ProjectPageResponse> discover({
    String? query,
    int? limit,
    int? offset,
  }) => _guard(
    () => _endpoint.discover(query: query, limit: limit, offset: offset),
  );

  @override
  Future<ProjectResponse> update(UuidValue id, UpdateProjectRequest request) =>
      _guard(() => _endpoint.update(id, request));

  @override
  Future<void> delete(UuidValue id) => _guard(() => _endpoint.delete(id));

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw mapGenericError(error);
    }
  }
}
