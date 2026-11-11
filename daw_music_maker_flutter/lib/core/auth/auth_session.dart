import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// The current user's authentication session, shared by every feature.
///
/// Wraps Serverpod's [FlutterAuthSessionManager] so routing and features do
/// not depend on the client directly (and can be faked in tests).
abstract interface class AuthSession {
  /// Whether a user is signed in on this device.
  bool get isAuthenticated;

  /// Notifies listeners whenever the user signs in or out.
  Listenable get changes;

  /// Signs the user out of this device. Never throws; the local session is
  /// cleared even when the server cannot be reached.
  Future<void> signOut();
}

/// [AuthSession] backed by the Serverpod client's session manager.
@LazySingleton(as: AuthSession)
class AuthSessionImpl implements AuthSession {
  /// Creates a session wrapper around [_manager].
  AuthSessionImpl(this._manager);

  final FlutterAuthSessionManager _manager;

  @override
  bool get isAuthenticated => _manager.isAuthenticated;

  @override
  Listenable get changes => _manager.authInfoListenable;

  @override
  Future<void> signOut() async {
    try {
      await _manager.signOutDevice();
    } catch (_) {
      // Signing out must always succeed locally.
      await _manager.updateSignedInUser(null);
    }
  }
}
