import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_impl.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    show
        EmailAccountLoginException,
        EmailAccountLoginExceptionReason,
        EmailAccountPasswordResetException,
        EmailAccountPasswordResetExceptionReason,
        EmailAccountRequestException,
        EmailAccountRequestExceptionReason;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    show AuthSuccess;

import '../../../helpers/mocks.dart';

void main() {
  late MockEndpointEmailIdp endpoint;
  late MockFlutterAuthSessionManager sessionManager;
  late AuthRepositoryImpl repository;

  final authSuccess = AuthSuccess(
    authStrategy: 'jwt',
    token: 'token',
    authUserId: testRequestId,
    scopeNames: const {},
  );

  setUpAll(() {
    registerTestFallbacks();
    registerFallbackValue(authSuccess);
  });

  setUp(() {
    endpoint = MockEndpointEmailIdp();
    sessionManager = MockFlutterAuthSessionManager();
    repository = AuthRepositoryImpl(endpoint, sessionManager);
    when(
      () => sessionManager.updateSignedInUser(any()),
    ).thenAnswer((_) async {});
  });

  group('Given login', () {
    test(
      'when credentials are valid, then normalizes the email and stores the session',
      () async {
        when(
          () => endpoint.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => authSuccess);

        await repository.login(
          email: '  Producer@Studio.FM ',
          password: 'secret123',
        );

        verify(
          () => endpoint.login(
            email: 'producer@studio.fm',
            password: 'secret123',
          ),
        ).called(1);
        verify(() => sessionManager.updateSignedInUser(authSuccess)).called(1);
      },
    );

    test('when credentials are wrong, then throws invalidCredentials', () {
      when(
        () => endpoint.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        EmailAccountLoginException(
          reason: EmailAccountLoginExceptionReason.invalidCredentials,
        ),
      );

      expect(
        repository.login(email: 'a@b.fm', password: 'x'),
        throwsA(const Failure(FailureCode.invalidCredentials)),
      );
      verifyNever(() => sessionManager.updateSignedInUser(any()));
    });

    test('when rate limited, then throws tooManyAttempts', () {
      when(
        () => endpoint.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        EmailAccountLoginException(
          reason: EmailAccountLoginExceptionReason.tooManyAttempts,
        ),
      );

      expect(
        repository.login(email: 'a@b.fm', password: 'x'),
        throwsA(const Failure(FailureCode.tooManyAttempts)),
      );
    });

    test('when the server is unreachable, then throws network', () {
      when(
        () => endpoint.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const ServerpodClientNetworkException('offline'));

      expect(
        repository.login(email: 'a@b.fm', password: 'x'),
        throwsA(const Failure(FailureCode.network)),
      );
    });
  });

  group('Given registration', () {
    test('when starting, then sends the normalized email', () async {
      when(
        () => endpoint.startRegistration(email: any(named: 'email')),
      ).thenAnswer((_) async => testRequestId);

      final id = await repository.startRegistration(email: ' A@B.FM ');

      expect(id, testRequestId);
      verify(() => endpoint.startRegistration(email: 'a@b.fm')).called(1);
    });

    test('when verifying a wrong code, then throws codeInvalid', () {
      when(
        () => endpoint.verifyRegistrationCode(
          accountRequestId: any(named: 'accountRequestId'),
          verificationCode: any(named: 'verificationCode'),
        ),
      ).thenThrow(
        EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.invalid,
        ),
      );

      expect(
        repository.verifyRegistrationCode(
          requestId: testRequestId,
          code: '12345678',
        ),
        throwsA(const Failure(FailureCode.codeInvalid)),
      );
    });

    test('when verifying an expired code, then throws codeExpired', () {
      when(
        () => endpoint.verifyRegistrationCode(
          accountRequestId: any(named: 'accountRequestId'),
          verificationCode: any(named: 'verificationCode'),
        ),
      ).thenThrow(
        EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.expired,
        ),
      );

      expect(
        repository.verifyRegistrationCode(
          requestId: testRequestId,
          code: '12345678',
        ),
        throwsA(const Failure(FailureCode.codeExpired)),
      );
    });

    test('when finishing, then stores the new session', () async {
      when(
        () => endpoint.finishRegistration(
          registrationToken: any(named: 'registrationToken'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => authSuccess);

      await repository.finishRegistration(
        registrationToken: 'reg-token',
        password: 'secret123',
      );

      verify(() => sessionManager.updateSignedInUser(authSuccess)).called(1);
    });

    test(
      'when the password violates the policy, then throws passwordPolicy',
      () {
        when(
          () => endpoint.finishRegistration(
            registrationToken: any(named: 'registrationToken'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.policyViolation,
          ),
        );

        expect(
          repository.finishRegistration(registrationToken: 't', password: 'p'),
          throwsA(const Failure(FailureCode.passwordPolicy)),
        );
      },
    );
  });

  group('Given password reset', () {
    test('when verifying the code, then returns the reset token', () async {
      when(
        () => endpoint.verifyPasswordResetCode(
          passwordResetRequestId: any(named: 'passwordResetRequestId'),
          verificationCode: any(named: 'verificationCode'),
        ),
      ).thenAnswer((_) async => 'reset-token');

      final token = await repository.verifyPasswordResetCode(
        requestId: testRequestId,
        code: ' 12345678 ',
      );

      expect(token, 'reset-token');
      verify(
        () => endpoint.verifyPasswordResetCode(
          passwordResetRequestId: testRequestId,
          verificationCode: '12345678',
        ),
      ).called(1);
    });

    test('when requests are rate limited, then throws tooManyAttempts', () {
      when(
        () => endpoint.startPasswordReset(email: any(named: 'email')),
      ).thenThrow(
        EmailAccountPasswordResetException(
          reason: EmailAccountPasswordResetExceptionReason.tooManyAttempts,
        ),
      );

      expect(
        repository.startPasswordReset(email: 'a@b.fm'),
        throwsA(const Failure(FailureCode.tooManyAttempts)),
      );
    });

    test('when finishing, then sends the token and new password', () async {
      when(
        () => endpoint.finishPasswordReset(
          finishPasswordResetToken: any(named: 'finishPasswordResetToken'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      await repository.finishPasswordReset(
        resetToken: 'reset-token',
        newPassword: 'new-secret',
      );

      verify(
        () => endpoint.finishPasswordReset(
          finishPasswordResetToken: 'reset-token',
          newPassword: 'new-secret',
        ),
      ).called(1);
    });
  });
}
