import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// Email + password authentication backed by Serverpod's email identity
/// provider.
///
/// Every method throws a `Failure` (see `core/errors/failure.dart`) on error.
/// Methods that complete a sign-in also store the session, which triggers the
/// router's auth redirect.
abstract interface class AuthRepository {
  /// Signs in with [email] and [password].
  Future<void> login({required String email, required String password});

  /// Starts a registration and emails a verification code to [email].
  ///
  /// Always returns a request id, even when the email is already registered,
  /// so accounts cannot be enumerated.
  Future<UuidValue> startRegistration({required String email});

  /// Exchanges the emailed [code] for a registration token.
  Future<String> verifyRegistrationCode({
    required UuidValue requestId,
    required String code,
  });

  /// Creates the account with [password] and signs the user in.
  Future<void> finishRegistration({
    required String registrationToken,
    required String password,
  });

  /// Emails a password-reset code to [email] if it is registered.
  ///
  /// Always returns a request id so accounts cannot be enumerated.
  Future<UuidValue> startPasswordReset({required String email});

  /// Exchanges the emailed [code] for a password-reset token.
  Future<String> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  });

  /// Sets [newPassword] using the [resetToken] from [verifyPasswordResetCode].
  Future<void> finishPasswordReset({
    required String resetToken,
    required String newPassword,
  });
}
