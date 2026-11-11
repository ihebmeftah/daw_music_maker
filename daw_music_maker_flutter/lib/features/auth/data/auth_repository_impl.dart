import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    show
        EmailAccountLoginException,
        EmailAccountLoginExceptionReason,
        EmailAccountPasswordResetException,
        EmailAccountPasswordResetExceptionReason,
        EmailAccountRequestException,
        EmailAccountRequestExceptionReason;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    show FlutterAuthSessionManager;

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failure.dart';
import 'auth_repository.dart';

/// [AuthRepository] that calls the server's `emailIdp` endpoint.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates the repository from the email endpoint and session manager.
  AuthRepositoryImpl(this._endpoint, this._sessionManager);

  final EndpointEmailIdp _endpoint;
  final FlutterAuthSessionManager _sessionManager;

  @override
  Future<void> login({required String email, required String password}) {
    return _guard(() async {
      final authSuccess = await _endpoint.login(
        email: _normalize(email),
        password: password,
      );
      await _sessionManager.updateSignedInUser(authSuccess);
    });
  }

  @override
  Future<UuidValue> startRegistration({required String email}) {
    return _guard(() => _endpoint.startRegistration(email: _normalize(email)));
  }

  @override
  Future<String> verifyRegistrationCode({
    required UuidValue requestId,
    required String code,
  }) {
    return _guard(
      () => _endpoint.verifyRegistrationCode(
        accountRequestId: requestId,
        verificationCode: code.trim(),
      ),
    );
  }

  @override
  Future<void> finishRegistration({
    required String registrationToken,
    required String password,
  }) {
    return _guard(() async {
      final authSuccess = await _endpoint.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await _sessionManager.updateSignedInUser(authSuccess);
    });
  }

  @override
  Future<UuidValue> startPasswordReset({required String email}) {
    return _guard(() => _endpoint.startPasswordReset(email: _normalize(email)));
  }

  @override
  Future<String> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  }) {
    return _guard(
      () => _endpoint.verifyPasswordResetCode(
        passwordResetRequestId: requestId,
        verificationCode: code.trim(),
      ),
    );
  }

  @override
  Future<void> finishPasswordReset({
    required String resetToken,
    required String newPassword,
  }) {
    return _guard(
      () => _endpoint.finishPasswordReset(
        finishPasswordResetToken: resetToken,
        newPassword: newPassword,
      ),
    );
  }

  String _normalize(String email) => email.trim().toLowerCase();

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw mapAuthError(error);
    }
  }
}

/// Maps email identity provider exceptions to a [Failure].
Failure mapAuthError(Object error) {
  return switch (error) {
    EmailAccountLoginException(:final reason) => Failure(switch (reason) {
      EmailAccountLoginExceptionReason.invalidCredentials =>
        FailureCode.invalidCredentials,
      EmailAccountLoginExceptionReason.tooManyAttempts =>
        FailureCode.tooManyAttempts,
      EmailAccountLoginExceptionReason.unknown => FailureCode.unknown,
    }),
    EmailAccountRequestException(:final reason) => Failure(switch (reason) {
      EmailAccountRequestExceptionReason.expired => FailureCode.codeExpired,
      EmailAccountRequestExceptionReason.invalid => FailureCode.codeInvalid,
      EmailAccountRequestExceptionReason.policyViolation =>
        FailureCode.passwordPolicy,
      EmailAccountRequestExceptionReason.tooManyAttempts =>
        FailureCode.tooManyAttempts,
      EmailAccountRequestExceptionReason.unknown => FailureCode.unknown,
    }),
    EmailAccountPasswordResetException(:final reason) => Failure(
      switch (reason) {
        EmailAccountPasswordResetExceptionReason.expired =>
          FailureCode.codeExpired,
        EmailAccountPasswordResetExceptionReason.invalid =>
          FailureCode.codeInvalid,
        EmailAccountPasswordResetExceptionReason.policyViolation =>
          FailureCode.passwordPolicy,
        EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
          FailureCode.tooManyAttempts,
        EmailAccountPasswordResetExceptionReason.unknown => FailureCode.unknown,
      },
    ),
    _ => mapGenericError(error),
  };
}
