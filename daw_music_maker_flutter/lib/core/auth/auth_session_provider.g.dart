// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [AuthSession] registered in get_it to Riverpod.

@ProviderFor(authSession)
final authSessionProvider = AuthSessionProvider._();

/// Exposes the [AuthSession] registered in get_it to Riverpod.

final class AuthSessionProvider
    extends $FunctionalProvider<AuthSession, AuthSession, AuthSession>
    with $Provider<AuthSession> {
  /// Exposes the [AuthSession] registered in get_it to Riverpod.
  AuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionHash();

  @$internal
  @override
  $ProviderElement<AuthSession> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSession create(Ref ref) {
    return authSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSession>(value),
    );
  }
}

String _$authSessionHash() => r'f00efe25df809a2904fd4d65db6349cce383fa58';
