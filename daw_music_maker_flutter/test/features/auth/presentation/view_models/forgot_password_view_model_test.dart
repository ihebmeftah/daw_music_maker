import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_provider.dart';
import 'package:daw_music_maker/features/auth/presentation/state/email_code_flow_state.dart';
import 'package:daw_music_maker/features/auth/presentation/view_models/forgot_password_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  EmailCodeFlowState read() => container.read(forgotPasswordViewModelProvider);
  ForgotPasswordViewModel notifier() =>
      container.read(forgotPasswordViewModelProvider.notifier);

  setUpAll(registerTestFallbacks);

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(forgotPasswordViewModelProvider, (_, _) {});
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
    ).thenAnswer((_) async {});
  });

  Future<void> reachPasswordStep() async {
    await notifier().submitEmail('Lost@Key.FM');
    await notifier().submitCode('12345678');
  }

  group('Given the ForgotPasswordViewModel', () {
    test('when the email is submitted, then moves to the code step', () async {
      await notifier().submitEmail('Lost@Key.FM');

      expect(read().step, EmailCodeFlowStep.verify);
      expect(read().email, 'lost@key.fm');
    });

    test(
      'when the code is valid, then moves to the new-password step',
      () async {
        await reachPasswordStep();

        expect(read().step, EmailCodeFlowStep.password);
        expect(read().token, 'reset-token');
      },
    );

    test(
      'when the new password is set, then resets it and signs in with it',
      () async {
        await reachPasswordStep();

        await notifier().submitPassword('brand-new-1');

        verifyInOrder([
          () => repository.finishPasswordReset(
            resetToken: 'reset-token',
            newPassword: 'brand-new-1',
          ),
          () => repository.login(email: 'lost@key.fm', password: 'brand-new-1'),
        ]);
        expect(read().failure, isNull);
      },
    );

    test(
      'when the reset token expired, then shows codeExpired and does not sign in',
      () async {
        when(
          () => repository.finishPasswordReset(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(const Failure(FailureCode.codeExpired));
        await reachPasswordStep();

        await notifier().submitPassword('brand-new-1');

        expect(read().failure, const Failure(FailureCode.codeExpired));
        verifyNever(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    test('when too many reset requests, then shows tooManyAttempts', () async {
      when(
        () => repository.startPasswordReset(email: any(named: 'email')),
      ).thenThrow(const Failure(FailureCode.tooManyAttempts));

      await notifier().submitEmail('a@b.fm');

      expect(read().step, EmailCodeFlowStep.email);
      expect(read().failure, const Failure(FailureCode.tooManyAttempts));
    });
  });
}
