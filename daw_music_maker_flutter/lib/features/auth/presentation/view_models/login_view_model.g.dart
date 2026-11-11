// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the sign-in screen.
///
/// On success the session is stored by the repository and the router's auth
/// guard navigates to the projects screen.

@ProviderFor(LoginViewModel)
final loginViewModelProvider = LoginViewModelProvider._();

/// ViewModel of the sign-in screen.
///
/// On success the session is stored by the repository and the router's auth
/// guard navigates to the projects screen.
final class LoginViewModelProvider
    extends $NotifierProvider<LoginViewModel, LoginState> {
  /// ViewModel of the sign-in screen.
  ///
  /// On success the session is stored by the repository and the router's auth
  /// guard navigates to the projects screen.
  LoginViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginViewModelHash();

  @$internal
  @override
  LoginViewModel create() => LoginViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginViewModelHash() => r'f532da9478071b6b36fb142d9aaa90a1fa287f4d';

/// ViewModel of the sign-in screen.
///
/// On success the session is stored by the repository and the router's auth
/// guard navigates to the projects screen.

abstract class _$LoginViewModel extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginState, LoginState>,
              LoginState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
