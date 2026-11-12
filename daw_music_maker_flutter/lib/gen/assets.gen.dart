// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// Directory path: assets/audio/samples
  $AssetsAudioSamplesGen get samples => const $AssetsAudioSamplesGen();
}

class $AssetsAudioSamplesGen {
  const $AssetsAudioSamplesGen();

  /// File path: assets/audio/samples/closed_hat.wav
  String get closedHat => 'assets/audio/samples/closed_hat.wav';

  /// File path: assets/audio/samples/kick.wav
  String get kick => 'assets/audio/samples/kick.wav';

  /// File path: assets/audio/samples/metronome_accent.wav
  String get metronomeAccent => 'assets/audio/samples/metronome_accent.wav';

  /// File path: assets/audio/samples/metronome_beat.wav
  String get metronomeBeat => 'assets/audio/samples/metronome_beat.wav';

  /// File path: assets/audio/samples/open_hat.wav
  String get openHat => 'assets/audio/samples/open_hat.wav';

  /// File path: assets/audio/samples/snare.wav
  String get snare => 'assets/audio/samples/snare.wav';

  /// List of all assets
  List<String> get values => [
    closedHat,
    kick,
    metronomeAccent,
    metronomeBeat,
    openHat,
    snare,
  ];
}

abstract final class Assets {
  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const String config = 'assets/config.json';

  /// List of all assets
  static List<String> get values => [config];
}
