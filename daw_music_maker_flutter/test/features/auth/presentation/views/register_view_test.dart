import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/auth/presentation/views/register_view.dart';
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
      () => repository.startRegistration(email: any(named: 'email')),
    ).thenAnswer((_) async => testRequestId);
    when(
      () => repository.verifyRegistrationCode(
        requestId: any(named: 'requestId'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => 'reg-token');
    when(
      () => repository.finishRegistration(
        registrationToken: any(named: 'registrationToken'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => session.signIn());
  });

  Future<void> openRegister(WidgetTester tester) => tester.pumpDawApp(
    session: session,
    repository: repository,
    initialLocation: '/register',
  );

  Future<void> submitEmail(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(EmailStepForm.emailFieldKey),
      'new@artist.fm',
    );
    await tester.tap(find.byKey(EmailStepForm.submitKey));
    await tester.pumpAndSettle();
  }

  Future<void> submitCode(
    WidgetTester tester, [
    String code = '12345678',
  ]) async {
    await tester.enterText(find.byKey(CodeStepForm.codeFieldKey), code);
    await tester.tap(find.byKey(CodeStepForm.submitKey));
    await tester.pumpAndSettle();
  }

  group('Given the registration screen', () {
    testWidgets('when opened, then shows the email step', (tester) async {
      await openRegister(tester);

      expect(find.byType(RegisterView), findsOneWidget);
      expect(find.text('Claim your studio'), findsOneWidget);
      expect(find.byKey(EmailStepForm.emailFieldKey), findsOneWidget);
    });

    testWidgets('when the email is submitted, then shows the code step', (
      tester,
    ) async {
      await openRegister(tester);

      await submitEmail(tester);

      expect(find.byKey(CodeStepForm.codeFieldKey), findsOneWidget);
      expect(
        find.textContaining('new@artist.fm', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('when the code is too short, then shows a validation error', (
      tester,
    ) async {
      await openRegister(tester);
      await submitEmail(tester);

      await submitCode(tester, '123');

      expect(find.text('The code has 8 digits'), findsOneWidget);
      verifyNever(
        () => repository.verifyRegistrationCode(
          requestId: any(named: 'requestId'),
          code: any(named: 'code'),
        ),
      );
    });

    testWidgets('when the server rejects the code, then shows the error', (
      tester,
    ) async {
      when(
        () => repository.verifyRegistrationCode(
          requestId: any(named: 'requestId'),
          code: any(named: 'code'),
        ),
      ).thenThrow(const Failure(FailureCode.codeInvalid));
      await openRegister(tester);
      await submitEmail(tester);

      await submitCode(tester);

      expect(find.text(FailureCode.codeInvalid.message), findsOneWidget);
      expect(find.byKey(CodeStepForm.codeFieldKey), findsOneWidget);
    });

    testWidgets('when passwords do not match, then shows a mismatch error', (
      tester,
    ) async {
      await openRegister(tester);
      await submitEmail(tester);
      await submitCode(tester);

      await tester.enterText(
        find.byKey(PasswordStepForm.passwordFieldKey),
        'secret123',
      );
      await tester.enterText(
        find.byKey(PasswordStepForm.confirmFieldKey),
        'secret124',
      );
      await tester.tap(find.byKey(PasswordStepForm.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets(
      'when the whole flow is completed, then the user lands on /projects',
      (tester) async {
        await openRegister(tester);
        await submitEmail(tester);
        await submitCode(tester);

        await tester.enterText(
          find.byKey(PasswordStepForm.passwordFieldKey),
          'secret123',
        );
        await tester.enterText(
          find.byKey(PasswordStepForm.confirmFieldKey),
          'secret123',
        );
        await tester.tap(find.byKey(PasswordStepForm.submitKey));
        await tester.pumpAndSettle();

        verify(
          () => repository.finishRegistration(
            registrationToken: 'reg-token',
            password: 'secret123',
          ),
        ).called(1);
        expect(find.byType(ProjectsView), findsOneWidget);
      },
    );

    testWidgets('when tapping "Sign in", then returns to the login screen', (
      tester,
    ) async {
      await openRegister(tester);

      await tester.tap(find.byKey(RegisterView.loginKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
