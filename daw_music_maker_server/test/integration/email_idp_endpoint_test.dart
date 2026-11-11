import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Security-relevant behavior of the email identity provider endpoint used by
/// the Flutter auth screens (sign in, register, forgot password).
void main() {
  // Unique per run: the provider rate-limits per email address.
  final run = DateTime.now().microsecondsSinceEpoch;
  String email(String name) => '$name-$run@studio.fm';

  withServerpod(
    'Given the EmailIdp endpoint',
    // The email provider runs concurrent transactions (rate limiting), which
    // the default per-test rollback does not support.
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      tearDown(() async {
        final session = sessionBuilder.build();
        await EmailAccountRequest.db.deleteWhere(
          session,
          where: (t) => t.email.like('%-$run@studio.fm'),
        );
      });

      setUp(() {
        // withServerpod does not run lib/server.dart, so configure the email
        // provider the way the server does (codes are only logged in tests).
        AuthServices.set(
          identityProviderBuilders: [
            const EmailIdpConfig(secretHashPepper: 'test-pepper-0123456789'),
          ],
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
          ],
        );
      });

      test(
        'when logging in with an unknown account, then invalidCredentials is thrown',
        () async {
          await expectLater(
            endpoints.emailIdp.login(
              sessionBuilder,
              email: email('nobody'),
              password: 'whatever123',
            ),
            throwsA(
              isA<EmailAccountLoginException>().having(
                (e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      test(
        'when starting a password reset for an unknown email, then a request id is still returned',
        () async {
          // Same answer as for a real account: emails cannot be enumerated.
          final id = await endpoints.emailIdp.startPasswordReset(
            sessionBuilder,
            email: email('nobody'),
          );

          expect(id, isNotNull);
        },
      );

      test(
        'when verifying a registration with a wrong code, then the request is rejected',
        () async {
          final requestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: email('new'),
          );

          await expectLater(
            endpoints.emailIdp.verifyRegistrationCode(
              sessionBuilder,
              accountRequestId: requestId,
              verificationCode: '00000000',
            ),
            throwsA(isA<EmailAccountRequestException>()),
          );
        },
      );

      test(
        'when finishing a registration with an invalid token, then it is rejected',
        () async {
          await expectLater(
            endpoints.emailIdp.finishRegistration(
              sessionBuilder,
              registrationToken: 'not-a-real-token',
              password: 'secret123',
            ),
            throwsA(isA<EmailAccountRequestException>()),
          );
        },
      );
    },
  );
}
