// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the three-step password reset flow:
/// email → verification code → new password.
///
/// After the new password is set the user is signed in with it, so the
/// router's auth guard navigates straight to the projects screen.

@ProviderFor(ForgotPasswordViewModel)
final forgotPasswordViewModelProvider = ForgotPasswordViewModelProvider._();

/// ViewModel of the three-step password reset flow:
/// email → verification code → new password.
///
/// After the new password is set the user is signed in with it, so the
/// router's auth guard navigates straight to the projects screen.
final class ForgotPasswordViewModelProvider
    extends $NotifierProvider<ForgotPasswordViewModel, EmailCodeFlowState> {
  /// ViewModel of the three-step password reset flow:
  /// email → verification code → new password.
  ///
  /// After the new password is set the user is signed in with it, so the
  /// router's auth guard navigates straight to the projects screen.
  ForgotPasswordViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordViewModelHash();

  @$internal
  @override
  ForgotPasswordViewModel create() => ForgotPasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailCodeFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailCodeFlowState>(value),
    );
  }
}

String _$forgotPasswordViewModelHash() =>
    r'1840db08b43abc65759988e0e8fd218e868d5f56';

/// ViewModel of the three-step password reset flow:
/// email → verification code → new password.
///
/// After the new password is set the user is signed in with it, so the
/// router's auth guard navigates straight to the projects screen.

abstract class _$ForgotPasswordViewModel extends $Notifier<EmailCodeFlowState> {
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
