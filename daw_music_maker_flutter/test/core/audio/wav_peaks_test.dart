import 'dart:math' as math;
import 'dart:typed_data';

import 'package:daw_music_maker/core/audio/wav_peaks.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a mono WAV with [samples] (−1…1) at [bits] bits.
Uint8List buildWav(List<double> samples, {int bits = 16, int rate = 8000}) {
  final bytesPerSample = bits ~/ 8;
  final dataLength = samples.length * bytesPerSample;
  final data = ByteData(44 + dataLength);
  void ascii(int offset, String text) {
    for (var i = 0; i < text.length; i++) {
      data.setUint8(offset + i, text.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  data.setUint32(4, 36 + dataLength, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, rate, Endian.little);
  data.setUint32(28, rate * bytesPerSample, Endian.little);
  data.setUint16(32, bytesPerSample, Endian.little);
  data.setUint16(34, bits, Endian.little);
  ascii(36, 'data');
  data.setUint32(40, dataLength, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    if (bits == 16) {
      data.setInt16(44 + i * 2, (samples[i] * 32767).round(), Endian.little);
    } else {
      data.setUint8(44 + i, ((samples[i] + 1) * 127.5).round());
    }
  }
  return data.buffer.asUint8List();
}

void main() {
  group('Given wavPeaks', () {
    test(
      'when given a 16-bit sine, then returns 200 peaks near its amplitude',
      () {
        final wav = buildWav([
          for (var i = 0; i < 8000; i++)
            0.5 * math.sin(2 * math.pi * 440 * i / 8000),
        ]);

        final peaks = wavPeaks(wav)!;

        expect(peaks, hasLength(200));
        expect(peaks.reduce(math.max), closeTo(0.5, 0.01));
        expect(peaks.every((p) => p >= 0 && p <= 1), isTrue);
      },
    );

    test('when the audio is silent, then all peaks are zero', () {
      final peaks = wavPeaks(buildWav(List.filled(4000, 0)))!;

      expect(peaks.every((p) => p == 0), isTrue);
    });

    test('when given a custom count, then returns that many peaks', () {
      expect(
        wavPeaks(buildWav(List.filled(1000, 0.1)), count: 50),
        hasLength(50),
      );
    });

    test('when the bytes are not a WAV, then returns null', () {
      expect(wavPeaks(Uint8List.fromList(List.filled(100, 7))), isNull);
    });

    test('when the WAV is 8-bit, then returns null (unsupported)', () {
      expect(wavPeaks(buildWav(List.filled(100, 0.2), bits: 8)), isNull);
    });
  });
}
