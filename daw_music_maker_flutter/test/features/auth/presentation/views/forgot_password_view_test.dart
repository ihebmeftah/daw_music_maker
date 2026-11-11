import 'package:daw_music_maker/features/auth/presentation/views/forgot_password_view.dart';
import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/code_step_form.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/email_step_form.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/password_step_form.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late FakeAuthSession session;
  late MockAuthRepository repository;

  setUpAll(registerTestFallbacks);

  setUp(() {
    session = FakeAuthSession();
    repository = MockAuthRepository();
    when(
      () => repository.startPasswordReset(email: any(named: 'email')),
    ).thenAnswer((_) async => testRequestId);
    when(
      () => repository.verifyPasswordResetCode(
        requestId: any(named: 'requestId'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => 'reset-token');
    when(
      () => repository.finishPasswordReset(
        resetToken: any(named: 'resetToken'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => session.signIn());
  });

  Future<void> openReset(WidgetTester tester) => tester.pumpDawApp(
    session: session,
    repository: repository,
    initialLocation: '/forgot-password',
  );

  group('Given the forgot-password screen', () {
    testWidgets('when opened, then asks for the account email', (
      tester,
    ) async {
      await openReset(tester);

      expect(find.byType(ForgotPasswordView), findsOneWidget);
      expect(find.text('Lost the master key?'), findsOneWidget);
    });

    testWidgets('when the email is invalid, then shows a validation error', (
      tester,
    ) async {
      await openReset(tester);

      await tester.enterText(find.byKey(EmailStepForm.emailFieldKey), 'nope');
      await tester.tap(find.byKey(EmailStepForm.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('when a new code is requested, then confirms it was sent', (
      tester,
    ) async {
      await openReset(tester);
      await tester.enterText(
        find.byKey(EmailStepForm.emailFieldKey),
        'lost@key.fm',
      );
      await tester.tap(find.byKey(EmailStepForm.submitKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(CodeStepForm.resendKey));
      await tester.pumpAndSettle();

      expect(find.text('Code sent ✓'), findsOneWidget);
      verify(
        () => repository.startPasswordReset(email: 'lost@key.fm'),
      ).called(2);
    });

    testWidgets(
      'when the reset is completed, then the user is signed in on /projects',
      (tester) async {
        await openReset(tester);

        await tester.enterText(
          find.byKey(EmailStepForm.emailFieldKey),
          'lost@key.fm',
        );
        await tester.tap(find.byKey(EmailStepForm.submitKey));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(CodeStepForm.codeFieldKey),
          '12345678',
        );
        await tester.tap(find.byKey(CodeStepForm.submitKey));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(PasswordStepForm.passwordFieldKey),
          'brand-new-1',
        );
        await tester.enterText(
          find.byKey(PasswordStepForm.confirmFieldKey),
          'brand-new-1',
        );
        await tester.tap(find.byKey(PasswordStepForm.submitKey));
        await tester.pumpAndSettle();

        verify(
          () => repository.finishPasswordReset(
            resetToken: 'reset-token',
            newPassword: 'brand-new-1',
          ),
        ).called(1);
        verify(
          () => repository.login(email: 'lost@key.fm', password: 'brand-new-1'),
        ).called(1);
        expect(find.byType(ProjectsView), findsOneWidget);
      },
    );

    testWidgets('when tapping "Back to sign in", then shows the login screen', (
      tester,
    ) async {
      await openReset(tester);

      await tester.tap(find.byKey(ForgotPasswordView.loginKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
