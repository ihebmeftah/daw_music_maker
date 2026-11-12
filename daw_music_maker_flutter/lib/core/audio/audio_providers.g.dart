// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [AudioEngine] (from get_it), e.g. for previewing notes.

@ProviderFor(audioEngine)
final audioEngineProvider = AudioEngineProvider._();

/// The app's [AudioEngine] (from get_it), e.g. for previewing notes.

final class AudioEngineProvider
    extends $FunctionalProvider<AudioEngine, AudioEngine, AudioEngine>
    with $Provider<AudioEngine> {
  /// The app's [AudioEngine] (from get_it), e.g. for previewing notes.
  AudioEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioEngineHash();

  @$internal
  @override
  $ProviderElement<AudioEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioEngine create(Ref ref) {
    return audioEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioEngine>(value),
    );
  }
}

String _$audioEngineHash() => r'7b5d14cb3b24e9744f8a874a04b005f758eac78d';

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

/// Waveform outline of a built-in sample (read from the bundled WAV).

@ProviderFor(builtinPeaks)
final builtinPeaksProvider = BuiltinPeaksFamily._();

/// Waveform outline of a built-in sample (read from the bundled WAV).

final class BuiltinPeaksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<double>?>,
          List<double>?,
          FutureOr<List<double>?>
        >
    with $FutureModifier<List<double>?>, $FutureProvider<List<double>?> {
  /// Waveform outline of a built-in sample (read from the bundled WAV).
  BuiltinPeaksProvider._({
    required BuiltinPeaksFamily super.from,
    required SampleKind super.argument,
  }) : super(
         retry: null,
         name: r'builtinPeaksProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$builtinPeaksHash();

  @override
  String toString() {
    return r'builtinPeaksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<double>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<double>?> create(Ref ref) {
    final argument = this.argument as SampleKind;
    return builtinPeaks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BuiltinPeaksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$builtinPeaksHash() => r'879b928e1661d00809f6efd3fef977195855c785';

/// Waveform outline of a built-in sample (read from the bundled WAV).

final class BuiltinPeaksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<double>?>, SampleKind> {
  BuiltinPeaksFamily._()
    : super(
        retry: null,
        name: r'builtinPeaksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Waveform outline of a built-in sample (read from the bundled WAV).

  BuiltinPeaksProvider call(SampleKind kind) =>
      BuiltinPeaksProvider._(argument: kind, from: this);

  @override
  String toString() => r'builtinPeaksProvider';
}
