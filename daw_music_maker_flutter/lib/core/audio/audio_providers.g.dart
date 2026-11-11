// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A fresh [Metronome] (from get_it) per consumer lifetime; disposed when no
/// longer watched, which also stops it.

@ProviderFor(metronome)
final metronomeProvider = MetronomeProvider._();

/// A fresh [Metronome] (from get_it) per consumer lifetime; disposed when no
/// longer watched, which also stops it.

final class MetronomeProvider
    extends $FunctionalProvider<Metronome, Metronome, Metronome>
    with $Provider<Metronome> {
  /// A fresh [Metronome] (from get_it) per consumer lifetime; disposed when no
  /// longer watched, which also stops it.
  MetronomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metronomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metronomeHash();

  @$internal
  @override
  $ProviderElement<Metronome> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Metronome create(Ref ref) {
    return metronome(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Metronome value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Metronome>(value),
    );
  }
}

String _$metronomeHash() => r'ce8331076dc79a73fa6713b5df030d64e70846ce';
