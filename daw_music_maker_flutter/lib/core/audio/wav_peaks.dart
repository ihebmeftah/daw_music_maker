import 'dart:math' as math;
import 'dart:typed_data';

/// Waveform outline (0–1 peaks) of a 16-bit PCM WAV, used to draw the
/// built-in samples in the sampler. Returns null for other files.
List<double>? wavPeaks(Uint8List bytes, {int count = 200}) {
  if (bytes.length < 44 ||
      String.fromCharCodes(bytes.sublist(0, 4)) != 'RIFF' ||
      String.fromCharCodes(bytes.sublist(8, 12)) != 'WAVE') {
    return null;
  }
  final data = ByteData.sublistView(bytes);
  int? channels;
  int? bits;
  var offset = 12;
  while (offset + 8 <= bytes.length) {
    final id = String.fromCharCodes(bytes.sublist(offset, offset + 4));
    final size = data.getUint32(offset + 4, Endian.little);
    final body = offset + 8;
    if (id == 'fmt ') {
      channels = data.getUint16(body + 2, Endian.little);
      bits = data.getUint16(body + 14, Endian.little);
    } else if (id == 'data') {
      if (channels == null || bits != 16 || channels == 0) return null;
      final frameSize = 2 * channels;
      final frames = math.min(size, bytes.length - body) ~/ frameSize;
      if (frames == 0) return List.filled(count, 0);
      return [
        for (var p = 0; p < count; p++)
          () {
            final start = p * frames ~/ count;
            final end = math.max(start + 1, (p + 1) * frames ~/ count);
            var peak = 0.0;
            for (var f = start; f < end && f < frames; f++) {
              final v =
                  data.getInt16(body + f * frameSize, Endian.little).abs() /
                  32768;
              if (v > peak) peak = v;
            }
            return math.min(1.0, peak);
          }(),
      ];
    }
    offset = body + size + (size.isOdd ? 1 : 0);
  }
  return null;
}
