import 'package:daw_music_maker/core/auth/auth_session.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository.dart';
import 'package:daw_music_maker/features/projects/data/collaboration_repository.dart';
import 'package:daw_music_maker/features/projects/data/project_repository.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Mock of the auth repository used by ViewModel and view tests.
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock of the project repository.
class MockProjectRepository extends Mock implements ProjectRepository {}

/// Mock of the collaboration repository.
class MockCollaborationRepository extends Mock
    implements CollaborationRepository {}

/// Mock of the generated project endpoint.
class MockEndpointProject extends Mock implements EndpointProject {}

/// Mock of the generated collaboration endpoint.
class MockEndpointProjectCollaboration extends Mock
    implements EndpointProjectCollaboration {}

/// Mock of the generated email identity provider endpoint.
class MockEndpointEmailIdp extends Mock implements EndpointEmailIdp {}

/// Mock of Serverpod's Flutter session manager.
class MockFlutterAuthSessionManager extends Mock
    implements FlutterAuthSessionManager {}

/// In-memory [AuthSession] whose state tests can flip.
class FakeAuthSession implements AuthSession {
  /// Creates a session, signed in when [signedIn] is true.
  FakeAuthSession({bool signedIn = false}) : _state = ValueNotifier(signedIn);

  final ValueNotifier<bool> _state;

  /// Number of [signOut] calls.
  int signOutCalls = 0;

  /// Simulates a successful sign-in.
  void signIn() => _state.value = true;

  @override
  bool get isAuthenticated => _state.value;

  @override
  Listenable get changes => _state;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _state.value = false;
  }
}

/// A fixed request id for tests.
final testRequestId = UuidValue.fromString(
  '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e5f',
);

/// A second fixed id for tests.
final otherTestId = UuidValue.fromString(
  '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e60',
);

/// Builds a [ProjectResponse] for tests.
ProjectResponse testProject({
  UuidValue? id,
  String name = 'Midnight Drive',
  String description = 'Synthwave sketch',
  List<String> genres = const ['synthwave'],
  ProjectVisibility visibility = ProjectVisibility.private,
  bool allowContributions = false,
  ProjectAccess access = ProjectAccess.owner,
  int memberCount = 0,
  bool hasPendingJoinRequest = false,
}) => ProjectResponse(
  id: id ?? testRequestId,
  ownerId: otherTestId,
  name: name,
  description: description,
  genres: genres,
  visibility: visibility,
  allowContributions: allowContributions,
  access: access,
  memberCount: memberCount,
  hasPendingJoinRequest: hasPendingJoinRequest,
  createdAt: DateTime.utc(2026, 11, 1),
  updatedAt: DateTime.utc(2026, 11, 2),
);

/// An empty project page.
final emptyPage = ProjectPageResponse(items: [], hasMore: false);

/// Registers mocktail fallback values for custom argument types.
void registerTestFallbacks() {
  registerFallbackValue(testRequestId);
  registerFallbackValue(ProjectRole.read);
  registerFallbackValue(
    CreateProjectRequest(
      name: 'x',
      description: '',
      genres: [],
      visibility: ProjectVisibility.private,
      allowContributions: false,
    ),
  );
  registerFallbackValue(
    UpdateProjectRequest(
      name: 'x',
      description: '',
      genres: [],
      visibility: ProjectVisibility.private,
      allowContributions: false,
    ),
  );
}

/// Stubs the list calls of [projects] with empty pages.
void stubEmptyProjectLists(MockProjectRepository projects) {
  when(
    () => projects.listMine(
      limit: any(named: 'limit'),
      offset: any(named: 'offset'),
    ),
  ).thenAnswer((_) async => emptyPage);
  when(
    () => projects.listShared(
      limit: any(named: 'limit'),
      offset: any(named: 'offset'),
    ),
  ).thenAnswer((_) async => emptyPage);
  when(
    () => projects.discover(
      query: any(named: 'query'),
      limit: any(named: 'limit'),
      offset: any(named: 'offset'),
    ),
  ).thenAnswer((_) async => emptyPage);
}

/// Stubs the inbox calls of [collab] with empty lists.
void stubEmptyInbox(MockCollaborationRepository collab) {
  when(collab.myInvitations).thenAnswer((_) async => []);
  when(collab.myJoinRequests).thenAnswer((_) async => []);
}
