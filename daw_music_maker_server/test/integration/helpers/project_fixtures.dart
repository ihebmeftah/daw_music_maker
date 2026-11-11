import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

/// A test user with an email account and an authenticated session builder.
class TestUser {
  /// Creates a test user.
  TestUser(this.id, this.email, this.session);

  /// Auth user id.
  final UuidValue id;

  /// Email address of the user's email account.
  final String email;

  /// Session builder authenticated as this user.
  final TestSessionBuilder session;
}

/// Configures auth services the way the server does (withServerpod does not
/// run `lib/server.dart`).
void configureTestAuth() {
  AuthServices.set(
    identityProviderBuilders: [
      const EmailIdpConfig(secretHashPepper: 'test-pepper-0123456789'),
    ],
    tokenManagerBuilders: [
      ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
    ],
  );
}

/// Unique email for this test run.
String uniqueEmail(String name) =>
    '$name-${DateTime.now().microsecondsSinceEpoch}@studio.fm';

/// Creates an auth user with an email account for [email].
Future<TestUser> createUser(TestSessionBuilder builder, String email) async {
  final session = builder.build();
  final user = await AuthServices.instance.authUsers.create(session);
  await EmailAccount.db.insertRow(
    session,
    EmailAccount(authUserId: user.id, email: email, passwordHash: 'unused'),
  );
  return TestUser(
    user.id,
    email,
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        user.id.uuid,
        {},
      ),
    ),
  );
}

/// A valid create request.
CreateProjectRequest createRequest({
  String name = 'Night Drive',
  String description = 'Synthwave sketch',
  List<String> genres = const ['Synthwave'],
  ProjectVisibility visibility = ProjectVisibility.private,
  bool allowContributions = false,
}) => CreateProjectRequest(
  name: name,
  description: description,
  genres: genres,
  visibility: visibility,
  allowContributions: allowContributions,
);

/// An update request copying [project] with optional overrides.
UpdateProjectRequest updateRequest(
  ProjectResponse project, {
  String? name,
  List<String>? genres,
  ProjectVisibility? visibility,
  bool? allowContributions,
}) => UpdateProjectRequest(
  name: name ?? project.name,
  description: project.description,
  genres: genres ?? project.genres,
  visibility: visibility ?? project.visibility,
  allowContributions: allowContributions ?? project.allowContributions,
);

/// Matches an [AppException] with [code].
Matcher throwsAppException(ErrorCode code) =>
    throwsA(isA<AppException>().having((e) => e.code, 'code', code));

/// Matches the exception thrown for unauthenticated calls.
final Matcher throwsUnauthenticated = throwsA(
  isA<ServerpodUnauthenticatedException>(),
);
