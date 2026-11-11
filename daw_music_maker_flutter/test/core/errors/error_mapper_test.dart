import 'dart:async';

import 'package:daw_music_maker/core/errors/error_mapper.dart';
import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    show AuthUserBlockedException;

void main() {
  group('Given mapGenericError', () {
    test('when given a Failure, then returns it unchanged', () {
      const failure = Failure(FailureCode.codeExpired);
      expect(mapGenericError(failure), same(failure));
    });

    test('when the server is unreachable, then maps to network', () {
      expect(
        mapGenericError(const ServerpodClientNetworkException('offline')),
        const Failure(FailureCode.network),
      );
      expect(
        mapGenericError(TimeoutException('slow')),
        const Failure(FailureCode.network),
      );
    });

    test('when the user is blocked, then maps to accountBlocked', () {
      expect(
        mapGenericError(AuthUserBlockedException()),
        const Failure(FailureCode.accountBlocked),
      );
    });

    test('when anything else, then maps to unknown', () {
      expect(
        mapGenericError(StateError('boom')),
        const Failure(FailureCode.unknown),
      );
    });
  });

  group('Given FailureCode messages', () {
    test('when read, then every code has a non-empty friendly message', () {
      for (final code in FailureCode.values) {
        expect(code.message, isNotEmpty);
      }
    });
  });
}
