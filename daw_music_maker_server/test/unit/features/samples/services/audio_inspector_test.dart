import 'dart:typed_data';

import 'package:daw_music_maker_server/src/features/samples/services/audio_inspector.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../../../helpers/wav_builder.dart';

void main() {
  group('Given AudioInspector.formatFromName', () {
    test('when the extension is supported, then returns its format', () {
      expect(AudioInspector.formatFromName('kick.wav'), AudioFormat.wav);
      expect(AudioInspector.formatFromName('KICK.WAVE'), AudioFormat.wav);
      expect(AudioInspector.formatFromName('loop.mp3'), AudioFormat.mp3);
      expect(AudioInspector.formatFromName('pad.ogg'), AudioFormat.ogg);
      expect(AudioInspector.formatFromName('pad.oga'), AudioFormat.ogg);
      expect(AudioInspector.formatFromName('vox.Flac'), AudioFormat.flac);
    });

    test('when unsupported or missing, then returns null', () {
      expect(AudioInspector.formatFromName('song.aiff'), isNull);
      expect(AudioInspector.formatFromName('kick'), isNull);
      expect(AudioInspector.formatFromName('kick.wav.exe'), isNull);
    });
  });

  group('Given AudioInspector.displayName', () {
    test('when given a path, then strips directories and extension', () {
      expect(AudioInspector.displayName('/tmp/drums/Big Kick.wav'), 'Big Kick');
      expect(AudioInspector.displayName(r'C:\drums\snare.mp3'), 'snare');
    });

    test('when padded, then trims', () {
      expect(AudioInspector.displayName('  hat  .wav'), 'hat');
    });

    test('when longer than 80 chars, then caps it', () {
      final name = AudioInspector.displayName('${'a' * 100}.wav');
      expect(name, hasLength(80));
    });

    test('when nothing remains, then defaults to Sample', () {
      expect(AudioInspector.displayName('   .wav'), 'Sample');
      expect(AudioInspector.displayName(''), 'Sample');
    });

    test('when the name starts with a dot, then keeps it', () {
      expect(AudioInspector.displayName('.hidden'), '.hidden');
    });
  });

  group('Given AudioInspector.matchesFormat', () {
    Uint8List bytes(List<int> values) => Uint8List.fromList(values);
    List<int> ascii(String s) => s.codeUnits;

    test('when bytes are a WAV, then matches wav only', () {
      final wav = buildWav(samples: [0, 0]);
      expect(AudioInspector.matchesFormat(wav, AudioFormat.wav), isTrue);
      expect(AudioInspector.matchesFormat(wav, AudioFormat.mp3), isFalse);
    });

    test('when RIFF is not WAVE, then it is not a WAV', () {
      final avi = bytes([...ascii('RIFF'), 0, 0, 0, 0, ...ascii('AVI ')]);
      expect(AudioInspector.matchesFormat(avi, AudioFormat.wav), isFalse);
    });

    test('when bytes start with ID3, then matches mp3', () {
      expect(
        AudioInspector.matchesFormat(bytes(ascii('ID3abc')), AudioFormat.mp3),
        isTrue,
      );
    });

    test('when an MP3 has a bare frame sync, then matches mp3', () {
      expect(
        AudioInspector.matchesFormat(
          bytes([0xFF, 0xFB, 0x90]),
          AudioFormat.mp3,
        ),
        isTrue,
      );
      expect(
        AudioInspector.matchesFormat(bytes([0xFF, 0x1B]), AudioFormat.mp3),
        isFalse,
      );
    });

    test('when bytes are Ogg or FLAC, then match their format', () {
      expect(
        AudioInspector.matchesFormat(bytes(ascii('OggS..')), AudioFormat.ogg),
        isTrue,
      );
      expect(
        AudioInspector.matchesFormat(bytes(ascii('fLaC..')), AudioFormat.flac),
        isTrue,
      );
      expect(
        AudioInspector.matchesFormat(bytes(ascii('OggS')), AudioFormat.flac),
        isFalse,
      );
    });

    test('when bytes are too short or empty, then nothing matches', () {
      for (final format in AudioFormat.values) {
        expect(AudioInspector.matchesFormat(bytes([]), format), isFalse);
      }
      expect(
        AudioInspector.matchesFormat(bytes(ascii('Ogg')), AudioFormat.ogg),
        isFalse,
      );
    });
  });

  group('Given AudioInspector.inspectWav', () {
    double maxPeak(List<double> peaks) => peaks.reduce((a, b) => a > b ? a : b);

    test('when a 1 s 16-bit mono sine, then 1000 ms and 200 peaks', () {
      final info = AudioInspector.inspectWav(buildWav(samples: sine()))!;

      expect(info.durationMs, 1000);
      expect(info.peaks, hasLength(AudioInspector.peakCount));
      expect(maxPeak(info.peaks), closeTo(0.5, 0.02));
      expect(info.peaks.every((p) => p >= 0 && p <= 1), isTrue);
    });

    test('when 8-bit, then reads the duration and peaks', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(amplitude: 0.8), bits: 8),
      )!;
      expect(info.durationMs, 1000);
      expect(maxPeak(info.peaks), closeTo(0.8, 0.03));
    });

    test('when 24-bit, then reads the duration and peaks', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(amplitude: 0.6), bits: 24),
      )!;
      expect(info.durationMs, 1000);
      expect(maxPeak(info.peaks), closeTo(0.6, 0.02));
    });

    test('when 32-bit float, then reads the duration and peaks', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(amplitude: 0.7), bits: 32, formatTag: 3),
      )!;
      expect(info.durationMs, 1000);
      expect(maxPeak(info.peaks), closeTo(0.7, 0.02));
    });

    test('when 32-bit integer PCM, then reads the peaks', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(amplitude: 0.4), bits: 32),
      )!;
      expect(maxPeak(info.peaks), closeTo(0.4, 0.02));
    });

    test('when stereo at 22.05 kHz, then the duration uses frames', () {
      final info = AudioInspector.inspectWav(
        buildWav(
          samples: sine(sampleRate: 22050, seconds: 2),
          sampleRate: 22050,
          channels: 2,
        ),
      )!;
      expect(info.durationMs, 2000);
    });

    test('when WAVE_FORMAT_EXTENSIBLE, then uses the sub-format', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(), extensible: true),
      )!;
      expect(info.durationMs, 1000);
      final float = AudioInspector.inspectWav(
        buildWav(samples: sine(), bits: 32, formatTag: 3, extensible: true),
      )!;
      expect(maxPeak(float.peaks), closeTo(0.5, 0.02));
    });

    test('when an odd-sized chunk precedes data, then it is skipped', () {
      final info = AudioInspector.inspectWav(
        buildWav(samples: sine(), extraChunk: true),
      )!;
      expect(info.durationMs, 1000);
    });

    test('when there is no audio data, then the duration is 0', () {
      final info = AudioInspector.inspectWav(buildWav(samples: []))!;
      expect(info.durationMs, 0);
      expect(info.peaks, everyElement(0));
    });

    test('when not a WAV, then returns null', () {
      expect(
        AudioInspector.inspectWav(Uint8List.fromList('OggS....'.codeUnits)),
        isNull,
      );
    });

    test('when the format tag is unsupported, then returns null', () {
      expect(
        AudioInspector.inspectWav(buildWav(samples: sine(), formatTag: 2)),
        isNull,
      );
    });
  });
}
