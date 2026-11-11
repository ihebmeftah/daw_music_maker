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

    test('when given an AppException, then maps every ErrorCode', () {
      const expected = {
        ErrorCode.notFound: FailureCode.notFound,
        ErrorCode.forbidden: FailureCode.forbidden,
        ErrorCode.validation: FailureCode.validation,
        ErrorCode.conflict: FailureCode.conflict,
        ErrorCode.limitReached: FailureCode.limitReached,
      };
      for (final code in ErrorCode.values) {
        expect(
          mapGenericError(AppException(code: code)).code,
          expected[code],
          reason: code.name,
        );
      }
    });

    test('when an AppException has fieldErrors, then keeps them', () {
      final failure = mapGenericError(
        AppException(
          code: ErrorCode.validation,
          fieldErrors: {'name': 'Name is required'},
        ),
      );

      expect(failure.fieldErrors, {'name': 'Name is required'});
      expect(failure.fieldError('name'), 'Name is required');
    });

    test('when an AppException has no fieldErrors, then they are empty', () {
      expect(
        mapGenericError(AppException(code: ErrorCode.forbidden)).fieldErrors,
        isEmpty,
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
