import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/project_service.dart';

/// Project CRUD and listing (`client.project`).
///
/// Requires a signed-in user. Every method throws [AppException]:
/// [ErrorCode.notFound] for projects the caller cannot see (private and not a
/// member, or nonexistent), [ErrorCode.forbidden] for actions the caller's
/// role does not allow, [ErrorCode.validation] with `fieldErrors` for invalid
/// input.
class ProjectEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = ProjectService();

  /// Creates a project owned by the caller.
  Future<ProjectResponse> create(
    Session session,
    CreateProjectRequest request,
  ) => _service.create(session, session.requireUserId, request);

  /// Returns a project the caller owns, is a member of, or that is public.
  Future<ProjectResponse> getById(Session session, UuidValue projectId) =>
      _service.getById(session, session.requireUserId, projectId);

  /// Projects owned by the caller, most recently changed first.
  /// [limit] is capped at 50 (default 20).
  Future<ProjectPageResponse> listMine(
    Session session, {
    int? limit,
    int? offset,
  }) => _service.listMine(
    session,
    session.requireUserId,
    limit: limit,
    offset: offset,
  );

  /// Projects the caller collaborates on (member, not owner).
  Future<ProjectPageResponse> listShared(
    Session session, {
    int? limit,
    int? offset,
  }) => _service.listShared(
    session,
    session.requireUserId,
    limit: limit,
    offset: offset,
  );

  /// Public projects of other users, optionally filtered by a case-insensitive
  /// name [query] (max 80 chars).
  Future<ProjectPageResponse> discover(
    Session session, {
    String? query,
    int? limit,
    int? offset,
  }) => _service.discover(
    session,
    session.requireUserId,
    query: query,
    limit: limit,
    offset: offset,
  );

  /// Replaces a project's details. Owner: everything; write members: name,
  /// description and genres only.
  Future<ProjectResponse> update(
    Session session,
    UuidValue projectId,
    UpdateProjectRequest request,
  ) => _service.update(session, session.requireUserId, projectId, request);

  /// Deletes a project with its members, invitations and join requests
  /// (owner only).
  Future<void> delete(Session session, UuidValue projectId) =>
      _service.delete(session, session.requireUserId, projectId);
}
