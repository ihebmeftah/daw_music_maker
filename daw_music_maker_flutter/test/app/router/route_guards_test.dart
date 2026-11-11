import 'package:daw_music_maker/app/router/route_guards.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? redirect(String location, {required bool signedIn}) =>
      authRedirect(isAuthenticated: signedIn, uri: Uri.parse(location));

  group('Given a signed-out user', () {
    test('when opening the home or root page, then goes to plain /login', () {
      expect(redirect('/projects', signedIn: false), '/login');
      expect(redirect('/', signedIn: false), '/login');
    });

    test('when opening a deep link, then goes to /login remembering it', () {
      final target = redirect('/projects/abc/studio', signedIn: false)!;
      final uri = Uri.parse(target);

      expect(uri.path, '/login');
      expect(uri.queryParameters['from'], '/projects/abc/studio');
    });

    test('when the deep link has a query, then it is kept in from', () {
      final uri = Uri.parse(redirect('/projects/form?id=x', signedIn: false)!);

      expect(uri.queryParameters['from'], '/projects/form?id=x');
    });

    test('when opening an auth page, then does not redirect', () {
      for (final path in authPaths) {
        expect(redirect(path, signedIn: false), isNull);
      }
    });
  });

  group('Given a signed-in user', () {
    test('when on an auth page without from, then goes to /projects', () {
      for (final path in authPaths) {
        expect(redirect(path, signedIn: true), '/projects');
      }
    });

    test('when on /login with a safe from, then returns to it', () {
      expect(
        redirect('/login?from=%2Fprojects%2Fabc%2Fstudio', signedIn: true),
        '/projects/abc/studio',
      );
    });

    test('when from points elsewhere, then ignores it (no open redirect)', () {
      for (final from in [
        'https://evil.example',
        '//evil.example/x',
        'javascript:alert(1)',
        '/login',
        'projects',
      ]) {
        expect(
          redirect('/login?from=${Uri.encodeComponent(from)}', signedIn: true),
          '/projects',
          reason: from,
        );
      }
    });

    test('when opening the root, then goes to /projects', () {
      expect(redirect('/', signedIn: true), '/projects');
    });

    test('when opening a protected page, then does not redirect', () {
      expect(redirect('/projects/abc/studio', signedIn: true), isNull);
    });
  });

  group('Given safeReturnPath', () {
    test('when given an app path, then accepts it', () {
      expect(safeReturnPath('/inbox'), '/inbox');
    });

    test('when empty or null, then returns null', () {
      expect(safeReturnPath(null), isNull);
      expect(safeReturnPath(''), isNull);
    });
  });
}
