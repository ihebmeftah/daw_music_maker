import 'package:daw_music_maker/core/auth/auth_session.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Mock of the auth repository used by ViewModel and view tests.
class MockAuthRepository extends Mock implements AuthRepository {}

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

/// Registers mocktail fallback values for custom argument types.
void registerTestFallbacks() {
  registerFallbackValue(testRequestId);
}
