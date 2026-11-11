/// Paths that are only reachable while signed out.
const Set<String> authPaths = {'/login', '/register', '/forgot-password'};

/// Path users land on after signing in.
const String homePath = '/projects';

/// Path signed-out users are sent to.
const String loginPath = '/login';

/// Auth redirect for go_router.
///
/// - Signed out on a protected path → [loginPath].
/// - Signed in on an auth path → [homePath] (this is how every sign-in,
///   registration and password reset ends on the projects screen).
/// - Otherwise `null` (no redirect).
String? authRedirect({
  required bool isAuthenticated,
  required String location,
}) {
  final onAuthPath = authPaths.contains(location);
  if (!isAuthenticated && !onAuthPath) return loginPath;
  if (isAuthenticated && onAuthPath) return homePath;
  return null;
}
