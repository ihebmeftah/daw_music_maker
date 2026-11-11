import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/auth_session_provider.dart';
import 'route_guards.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// The app's [GoRouter].
///
/// Re-evaluates [authRedirect] whenever the auth session changes, so signing
/// in moves the user to `/projects` and signing out back to `/login`.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final session = ref.watch(authSessionProvider);
  final router = GoRouter(
    initialLocation: homePath,
    routes: $appRoutes,
    refreshListenable: session.changes,
    redirect: (context, state) => authRedirect(
      isAuthenticated: session.isAuthenticated,
      location: state.matchedLocation,
    ),
  );
  ref.onDispose(router.dispose);
  return router;
}
