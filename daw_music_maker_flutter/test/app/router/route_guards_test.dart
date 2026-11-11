import 'package:daw_music_maker/app/router/route_guards.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given a signed-out user', () {
    test('when opening a protected path, then redirects to /login', () {
      expect(
        authRedirect(isAuthenticated: false, location: '/projects'),
        '/login',
      );
    });

    test('when opening an auth path, then does not redirect', () {
      for (final path in authPaths) {
        expect(authRedirect(isAuthenticated: false, location: path), isNull);
      }
    });
  });

  group('Given a signed-in user', () {
    test('when on any auth path, then redirects to /projects', () {
      for (final path in authPaths) {
        expect(
          authRedirect(isAuthenticated: true, location: path),
          '/projects',
        );
      }
    });

    test('when opening a protected path, then does not redirect', () {
      expect(
        authRedirect(isAuthenticated: true, location: '/projects'),
        isNull,
      );
    });
  });
}
