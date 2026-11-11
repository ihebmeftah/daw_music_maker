import 'dart:async';

import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Registers third-party infrastructure in get_it.
@module
abstract class RegisterModule {
  /// The Serverpod [Client], connected to the server URL from
  /// `--dart-define=SERVER_URL`, `assets/config.json` or localhost.
  ///
  /// The stored auth session is restored before the app starts (so the
  /// router knows whether the user is signed in), and validated with the
  /// server in the background.
  @preResolve
  @singleton
  Future<Client> client() async {
    final client = Client(await getServerUrl())
      ..connectivityMonitor = FlutterConnectivityMonitor()
      ..authSessionManager = FlutterAuthSessionManager();
    await client.auth.restore();
    unawaited(client.auth.validateAuthentication().catchError((_) => false));
    return client;
  }

  /// Email identity provider endpoint (register, login, password reset).
  @lazySingleton
  EndpointEmailIdp emailIdp(Client client) => client.emailIdp;

  /// Project CRUD endpoint.
  @lazySingleton
  EndpointProject projectEndpoint(Client client) => client.project;

  /// Members, invitations and join requests endpoint.
  @lazySingleton
  EndpointProjectCollaboration projectCollaborationEndpoint(Client client) =>
      client.projectCollaboration;

  /// The client's auth session manager (signed-in state, sign out).
  @lazySingleton
  FlutterAuthSessionManager authSessionManager(Client client) => client.auth;
}
