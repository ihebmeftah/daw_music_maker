import 'package:daw_music_maker_server/src/core/validation/validation_rules.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

/// These tests pin [ValidationRules] to the defaults of Serverpod's email
/// identity provider, so a Serverpod upgrade that changes the policy fails
/// here instead of silently drifting from the Flutter validators.
void main() {
  // Only the default policy functions are used; the pepper is irrelevant.
  const config = EmailIdpConfig(secretHashPepper: 'test-pepper');

  group('Given the email identity provider password policy', () {
    test(
      'when a password has exactly passwordMinLength characters, then it is accepted',
      () {
        final password = 'a' * ValidationRules.passwordMinLength;

        expect(config.passwordValidationFunction(password), isTrue);
      },
    );

    test(
      'when a password is one character shorter than passwordMinLength, then it is rejected',
      () {
        final password = 'a' * (ValidationRules.passwordMinLength - 1);

        expect(config.passwordValidationFunction(password), isFalse);
      },
    );

    test(
      'when a password has leading or trailing whitespace, then it is rejected',
      () {
        expect(config.passwordValidationFunction(' abcdefgh '), isFalse);
      },
    );
  });

  group('Given the default verification code generators', () {
    test(
      'when a registration code is generated, then it has verificationCodeLength digits',
      () {
        final code = config.registrationVerificationCodeGenerator();

        expect(code, hasLength(ValidationRules.verificationCodeLength));
        expect(code, matches(RegExp(r'^[1-9]+$')));
      },
    );

    test(
      'when a password reset code is generated, then it has verificationCodeLength digits',
      () {
        final code = config.passwordResetVerificationCodeGenerator();

        expect(code, hasLength(ValidationRules.verificationCodeLength));
      },
    );
  });
}
