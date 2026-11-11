// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [StudioRepository] registered in get_it to Riverpod.

@ProviderFor(studioRepository)
final studioRepositoryProvider = StudioRepositoryProvider._();

/// Exposes the [StudioRepository] registered in get_it to Riverpod.

final class StudioRepositoryProvider
    extends
        $FunctionalProvider<
          StudioRepository,
          StudioRepository,
          StudioRepository
        >
    with $Provider<StudioRepository> {
  /// Exposes the [StudioRepository] registered in get_it to Riverpod.
  StudioRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studioRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studioRepositoryHash();

  @$internal
  @override
  $ProviderElement<StudioRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StudioRepository create(Ref ref) {
    return studioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudioRepository>(value),
    );
  }
}

String _$studioRepositoryHash() => r'085cb9bdfafa33b0ae24372533e5983121b33d52';
