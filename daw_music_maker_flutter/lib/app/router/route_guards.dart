/// Paths that are only reachable while signed out.
const Set<String> authPaths = {'/login', '/register', '/forgot-password'};

/// Path users land on after signing in.
const String homePath = '/projects';

/// Path signed-out users are sent to.
const String loginPath = '/login';

/// Query parameter carrying the page to return to after signing in.
const String fromParam = 'from';

/// Returns [from] if it is a safe in-app location to return to after signing
/// in, otherwise null.
///
/// Only relative app paths are allowed (no scheme, no host, no `//`), and
/// never an auth page — this prevents open redirects through `?from=`.
String? safeReturnPath(String? from) {
  if (from == null || from.isEmpty) return null;
  if (!from.startsWith('/') || from.startsWith('//')) return null;
  final uri = Uri.tryParse(from);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (authPaths.contains(uri.path) || uri.path == '/') return null;
  return from;
}

/// Auth redirect for go_router, based on the full requested [uri].
///
/// - `/` → [homePath] (or the login page when signed out).
/// - Signed out on a protected page → [loginPath]`?from=<page>` so the user
///   comes back to it after signing in (deep links, browser refresh).
/// - Signed in on an auth page → the safe `from` page, else [homePath]. This
///   is how every sign-in, registration and password reset ends.
/// - Otherwise `null` (no redirect).
String? authRedirect({required bool isAuthenticated, required Uri uri}) {
  final path = uri.path;
  final onAuthPath = authPaths.contains(path);

  if (!isAuthenticated && !onAuthPath) {
    if (path == '/' || path == homePath) return loginPath;
    return Uri(
      path: loginPath,
      queryParameters: {fromParam: uri.toString()},
    ).toString();
  }
  if (isAuthenticated && onAuthPath) {
    return safeReturnPath(uri.queryParameters[fromParam]) ?? homePath;
  }
  if (path == '/') return homePath;
  return null;
}
