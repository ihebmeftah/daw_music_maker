// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.

@ProviderFor(StudioViewModel)
final studioViewModelProvider = StudioViewModelFamily._();

/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.
final class StudioViewModelProvider
    extends $AsyncNotifierProvider<StudioViewModel, StudioState> {
  /// ViewModel of the studio: tempo editing (with server persistence for
  /// owners and write members), tap tempo and the metronome transport.
  StudioViewModelProvider._({
    required StudioViewModelFamily super.from,
    required UuidValue super.argument,
  }) : super(
         retry: null,
         name: r'studioViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studioViewModelHash();

  @override
  String toString() {
    return r'studioViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StudioViewModel create() => StudioViewModel();

  @override
  bool operator ==(Object other) {
    return other is StudioViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studioViewModelHash() => r'964ad4ff0390999897dddc16cdd9fdaaa605842d';

/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.

final class StudioViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          StudioViewModel,
          AsyncValue<StudioState>,
          StudioState,
          FutureOr<StudioState>,
          UuidValue
        > {
  StudioViewModelFamily._()
    : super(
        retry: null,
        name: r'studioViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel of the studio: tempo editing (with server persistence for
  /// owners and write members), tap tempo and the metronome transport.

  StudioViewModelProvider call(UuidValue projectId) =>
      StudioViewModelProvider._(argument: projectId, from: this);

  @override
  String toString() => r'studioViewModelProvider';
}

/// ViewModel of the studio: tempo editing (with server persistence for
/// owners and write members), tap tempo and the metronome transport.

abstract class _$StudioViewModel extends $AsyncNotifier<StudioState> {
  late final _$args = ref.$arg as UuidValue;
  UuidValue get projectId => _$args;

  FutureOr<StudioState> build(UuidValue projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StudioState>, StudioState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StudioState>, StudioState>,
              AsyncValue<StudioState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
