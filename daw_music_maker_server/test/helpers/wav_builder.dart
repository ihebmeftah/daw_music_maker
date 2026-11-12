import 'dart:math' as math;
import 'dart:typed_data';

/// Builds an in-memory WAV file for tests.
///
/// [samples] are per-frame values in -1..1 (the same value is written to
/// every channel). [formatTag] 1 = PCM, 3 = float; [extensible] wraps the
/// format in WAVE_FORMAT_EXTENSIBLE; [extraChunk] adds an odd-sized chunk
/// (with its pad byte) before `data`.
Uint8List buildWav({
  required List<double> samples,
  int sampleRate = 44100,
  int channels = 1,
  int bits = 16,
  int formatTag = 1,
  bool extensible = false,
  bool extraChunk = false,
}) {
  final bytesPerSample = bits ~/ 8;
  final dataLength = samples.length * channels * bytesPerSample;
  final fmtLength = extensible ? 40 : 16;
  final extra = extraChunk ? 8 + 3 + 1 : 0;
  final total = 12 + 8 + fmtLength + extra + 8 + dataLength;
  final bytes = ByteData(total);
  var o = 0;
  void ascii(String s) {
    for (final c in s.codeUnits) {
      bytes.setUint8(o++, c);
    }
  }

  void u16(int v) {
    bytes.setUint16(o, v, Endian.little);
    o += 2;
  }

  void u32(int v) {
    bytes.setUint32(o, v, Endian.little);
    o += 4;
  }

  ascii('RIFF');
  u32(total - 8);
  ascii('WAVE');
  ascii('fmt ');
  u32(fmtLength);
  u16(extensible ? 0xFFFE : formatTag);
  u16(channels);
  u32(sampleRate);
  u32(sampleRate * channels * bytesPerSample);
  u16(channels * bytesPerSample);
  u16(bits);
  if (extensible) {
    u16(22); // cbSize
    u16(bits); // valid bits
    u32(0); // channel mask
    u16(formatTag); // sub-format GUID starts with the format tag
    for (var i = 0; i < 14; i++) {
      bytes.setUint8(o++, 0);
    }
  }
  if (extraChunk) {
    ascii('LIST');
    u32(3);
    for (var i = 0; i < 4; i++) {
      bytes.setUint8(o++, 0); // 3 bytes + pad byte
    }
  }
  ascii('data');
  u32(dataLength);
  for (final s in samples) {
    for (var c = 0; c < channels; c++) {
      switch ((bits, formatTag)) {
        case (32, 3):
          bytes.setFloat32(o, s, Endian.little);
        case (8, _):
          bytes.setUint8(o, (s * 127 + 128).round().clamp(0, 255));
        case (16, _):
          bytes.setInt16(o, (s * 32767).round(), Endian.little);
        case (24, _):
          final v = (s * 8388607).round() & 0xFFFFFF;
          bytes.setUint8(o, v & 0xFF);
          bytes.setUint8(o + 1, (v >> 8) & 0xFF);
          bytes.setUint8(o + 2, (v >> 16) & 0xFF);
        default:
          bytes.setInt32(o, (s * 2147483647).round(), Endian.little);
      }
      o += bytesPerSample;
    }
  }
  return bytes.buffer.asUint8List();
}

/// One second (by default) of a sine at [amplitude].
List<double> sine({
  double amplitude = 0.5,
  int sampleRate = 44100,
  double seconds = 1,
  double frequency = 440,
}) => [
  for (var i = 0; i < (sampleRate * seconds).round(); i++)
    amplitude * math.sin(2 * math.pi * frequency * i / sampleRate),
];
