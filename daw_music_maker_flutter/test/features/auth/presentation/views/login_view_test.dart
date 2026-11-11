import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/presentation/views/forgot_password_view.dart';
import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/auth/presentation/views/register_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late FakeAuthSession session;
  late MockAuthRepository repository;

  setUp(() {
    session = FakeAuthSession();
    repository = MockAuthRepository();
  });

  void stubLogin(Future<void> Function() answer) {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => answer());
  }

  Future<void> fillAndSubmit(
    WidgetTester tester, {
    String email = 'producer@studio.fm',
    String password = 'secret123',
  }) async {
    await tester.enterText(find.byKey(LoginView.emailFieldKey), email);
    await tester.enterText(find.byKey(LoginView.passwordFieldKey), password);
    await tester.tap(find.byKey(LoginView.submitKey));
    await tester.pumpAndSettle();
  }

  group('Given a signed-out user on the app', () {
    testWidgets('when it starts, then the login screen is shown', (
      tester,
    ) async {
      await tester.pumpDawApp(session: session, repository: repository);

      expect(find.byType(LoginView), findsOneWidget);
      expect(find.text('Back in the booth'), findsOneWidget);
    });

    testWidgets('when submitting an empty form, then shows field errors', (
      tester,
    ) async {
      await tester.pumpDawApp(session: session, repository: repository);

      await tester.tap(find.byKey(LoginView.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      verifyNever(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('when the email is malformed, then shows an email error', (
      tester,
    ) async {
      await tester.pumpDawApp(session: session, repository: repository);

      await fillAndSubmit(tester, email: 'not-an-email');

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets(
      'when credentials are valid, then signs in and lands on /projects',
      (tester) async {
        stubLogin(() async => session.signIn());
        await tester.pumpDawApp(session: session, repository: repository);

        await fillAndSubmit(tester);

        verify(
          () => repository.login(
            email: 'producer@studio.fm',
            password: 'secret123',
          ),
        ).called(1);
        expect(find.byType(ProjectsView), findsOneWidget);
        expect(find.byType(LoginView), findsNothing);
      },
    );

    testWidgets(
      'when credentials are wrong, then shows a friendly error and stays',
      (tester) async {
        stubLogin(
          () async => throw const Failure(FailureCode.invalidCredentials),
        );
        await tester.pumpDawApp(session: session, repository: repository);

        await fillAndSubmit(tester);

        expect(
          find.text(FailureCode.invalidCredentials.message),
          findsOneWidget,
        );
        expect(find.byType(LoginView), findsOneWidget);
      },
    );

    testWidgets('when tapping "Forgot password?", then opens the reset flow', (
      tester,
    ) async {
      await tester.pumpDawApp(session: session, repository: repository);

      await tester.tap(find.byKey(LoginView.forgotPasswordKey));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordView), findsOneWidget);
    });

    testWidgets('when tapping "Create an account", then opens registration', (
      tester,
    ) async {
      await tester.pumpDawApp(session: session, repository: repository);

      await tester.tap(find.byKey(LoginView.registerKey));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterView), findsOneWidget);
    });
  });

  group('Given a signed-in user', () {
    testWidgets('when opening /login, then is redirected to /projects', (
      tester,
    ) async {
      session = FakeAuthSession(signedIn: true);

      await tester.pumpDawApp(
        session: session,
        repository: repository,
        initialLocation: '/login',
      );

      expect(find.byType(ProjectsView), findsOneWidget);
    });
  });
}
