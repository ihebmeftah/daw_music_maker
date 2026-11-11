import 'dart:async';

import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    show AuthUserBlockedException;

import 'failure.dart';

/// Maps exceptions that are not feature-specific to a [Failure].
///
/// Feature repositories handle their own typed server exceptions first and
/// delegate everything else here.
Failure mapGenericError(Object error) {
  return switch (error) {
    Failure() => error,
    AuthUserBlockedException() => const Failure(FailureCode.accountBlocked),
    TimeoutException() => const Failure(FailureCode.network),
    ServerpodClientNetworkException() => const Failure(FailureCode.network),
    _ => const Failure(FailureCode.unknown),
  };
}
