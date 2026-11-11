import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_provider.dart';
import 'package:daw_music_maker/features/auth/presentation/state/email_code_flow_state.dart';
import 'package:daw_music_maker/features/auth/presentation/view_models/register_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  EmailCodeFlowState read() => container.read(registerViewModelProvider);
  RegisterViewModel notifier() =>
      container.read(registerViewModelProvider.notifier);

  setUpAll(registerTestFallbacks);

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(registerViewModelProvider, (_, _) {});
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
    ).thenAnswer((_) async {});
  });

  group('Given the RegisterViewModel', () {
    test('when created, then starts on the email step', () {
      expect(read().step, EmailCodeFlowStep.email);
    });

    test('when the email is submitted, then moves to the code step', () async {
      await notifier().submitEmail('  New@Artist.FM ');

      expect(read().step, EmailCodeFlowStep.verify);
      expect(read().email, 'new@artist.fm');
      expect(read().requestId, testRequestId);
      expect(read().isSubmitting, isFalse);
    });

    test('when the code is valid, then moves to the password step', () async {
      await notifier().submitEmail('a@b.fm');
      await notifier().submitCode('12345678');

      expect(read().step, EmailCodeFlowStep.password);
      expect(read().token, 'reg-token');
      verify(
        () => repository.verifyRegistrationCode(
          requestId: testRequestId,
          code: '12345678',
        ),
      ).called(1);
    });

    test(
      'when the code is wrong, then stays on the code step with an error',
      () async {
        when(
          () => repository.verifyRegistrationCode(
            requestId: any(named: 'requestId'),
            code: any(named: 'code'),
          ),
        ).thenThrow(const Failure(FailureCode.codeInvalid));
        await notifier().submitEmail('a@b.fm');

        await notifier().submitCode('11111111');

        expect(read().step, EmailCodeFlowStep.verify);
        expect(read().failure, const Failure(FailureCode.codeInvalid));
      },
    );

    test(
      'when the password is submitted, then finishes the registration',
      () async {
        await notifier().submitEmail('a@b.fm');
        await notifier().submitCode('12345678');

        await notifier().submitPassword('secret123');

        verify(
          () => repository.finishRegistration(
            registrationToken: 'reg-token',
            password: 'secret123',
          ),
        ).called(1);
        expect(read().failure, isNull);
      },
    );

    test(
      'when a new code is requested, then refreshes the request id',
      () async {
        await notifier().submitEmail('a@b.fm');

        await notifier().resendCode();

        expect(read().codeResent, isTrue);
        verify(() => repository.startRegistration(email: 'a@b.fm')).called(2);
      },
    );

    test('when restarting, then returns to an empty email step', () async {
      await notifier().submitEmail('a@b.fm');

      notifier().restart();

      expect(read(), const EmailCodeFlowState());
    });

    test('when offline, then exposes a network failure', () async {
      when(
        () => repository.startRegistration(email: any(named: 'email')),
      ).thenThrow(const Failure(FailureCode.network));

      await notifier().submitEmail('a@b.fm');

      expect(read().step, EmailCodeFlowStep.email);
      expect(read().failure, const Failure(FailureCode.network));
    });
  });
}
