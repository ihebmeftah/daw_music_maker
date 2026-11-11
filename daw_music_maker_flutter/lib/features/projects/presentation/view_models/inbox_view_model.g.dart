// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the inbox: invitations received and join requests sent.

@ProviderFor(InboxViewModel)
final inboxViewModelProvider = InboxViewModelProvider._();

/// ViewModel of the inbox: invitations received and join requests sent.
final class InboxViewModelProvider
    extends $AsyncNotifierProvider<InboxViewModel, InboxState> {
  /// ViewModel of the inbox: invitations received and join requests sent.
  InboxViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxViewModelHash();

  @$internal
  @override
  InboxViewModel create() => InboxViewModel();
}

String _$inboxViewModelHash() => r'893eeec3c0cae9153ab6f247e352ab9fbcce1045';

/// ViewModel of the inbox: invitations received and join requests sent.

abstract class _$InboxViewModel extends $AsyncNotifier<InboxState> {
  FutureOr<InboxState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<InboxState>, InboxState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InboxState>, InboxState>,
              AsyncValue<InboxState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
