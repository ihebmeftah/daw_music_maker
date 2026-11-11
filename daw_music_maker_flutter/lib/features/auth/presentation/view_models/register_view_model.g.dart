// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the three-step registration flow:
/// email → verification code → password.
///
/// Finishing the flow signs the user in; the router's auth guard then
/// navigates to the projects screen.

@ProviderFor(RegisterViewModel)
final registerViewModelProvider = RegisterViewModelProvider._();

/// ViewModel of the three-step registration flow:
/// email → verification code → password.
///
/// Finishing the flow signs the user in; the router's auth guard then
/// navigates to the projects screen.
final class RegisterViewModelProvider
    extends $NotifierProvider<RegisterViewModel, EmailCodeFlowState> {
  /// ViewModel of the three-step registration flow:
  /// email → verification code → password.
  ///
  /// Finishing the flow signs the user in; the router's auth guard then
  /// navigates to the projects screen.
  RegisterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerViewModelHash();

  @$internal
  @override
  RegisterViewModel create() => RegisterViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailCodeFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailCodeFlowState>(value),
    );
  }
}

String _$registerViewModelHash() => r'a61ec55ef42f1d096dcb2bfe8277b9bb11570c1c';

/// ViewModel of the three-step registration flow:
/// email → verification code → password.
///
/// Finishing the flow signs the user in; the router's auth guard then
/// navigates to the projects screen.

abstract class _$RegisterViewModel extends $Notifier<EmailCodeFlowState> {
  EmailCodeFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EmailCodeFlowState, EmailCodeFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmailCodeFlowState, EmailCodeFlowState>,
              EmailCodeFlowState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
