import 'dart:math' as math;
import 'dart:typed_data';

import '../../../generated/protocol.dart';

/// Facts about a WAV file read from its header and data.
typedef WavInfo = ({int durationMs, List<double> peaks});

/// Pure inspection of uploaded audio bytes (no database, no storage).
abstract final class AudioInspector {
  /// Number of points in a waveform outline.
  static const int peakCount = 200;

  /// The format named by [fileName]'s extension, or null if unsupported.
  static AudioFormat? formatFromName(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0) return null;
    return switch (fileName.substring(dot + 1).toLowerCase()) {
      'wav' || 'wave' => AudioFormat.wav,
      'mp3' => AudioFormat.mp3,
      'ogg' || 'oga' => AudioFormat.ogg,
      'flac' => AudioFormat.flac,
      _ => null,
    };
  }

  /// Display name: [fileName] without directory and extension, trimmed and
  /// capped at [maxLength]; "Sample" when nothing is left.
  static String displayName(String fileName, {int maxLength = 80}) {
    var name = fileName.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    if (dot > 0) name = name.substring(0, dot);
    name = name.trim();
    if (name.isEmpty) return 'Sample';
    return name.length > maxLength ? name.substring(0, maxLength) : name;
  }

  /// Whether [bytes] start like a file of [format] (magic numbers).
  static bool matchesFormat(Uint8List bytes, AudioFormat format) {
    bool ascii(int offset, String text) {
      if (bytes.length < offset + text.length) return false;
      for (var i = 0; i < text.length; i++) {
        if (bytes[offset + i] != text.codeUnitAt(i)) return false;
      }
      return true;
    }

    return switch (format) {
      AudioFormat.wav => ascii(0, 'RIFF') && ascii(8, 'WAVE'),
      AudioFormat.ogg => ascii(0, 'OggS'),
      AudioFormat.flac => ascii(0, 'fLaC'),
      AudioFormat.mp3 =>
        ascii(0, 'ID3') ||
            (bytes.length > 1 && bytes[0] == 0xFF && (bytes[1] & 0xE0) == 0xE0),
    };
  }

  /// Reads duration and a [peakCount]-point outline from a PCM / float WAV.
  /// Returns null when the file is not a WAV this parser understands.
  static WavInfo? inspectWav(Uint8List bytes) {
    if (!matchesFormat(bytes, AudioFormat.wav)) return null;
    final data = ByteData.sublistView(bytes);
    int? formatTag;
    int? channels;
    int? sampleRate;
    int? bits;
    int? dataOffset;
    int? dataLength;

    var offset = 12;
    while (offset + 8 <= bytes.length) {
      final id = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final size = data.getUint32(offset + 4, Endian.little);
      final body = offset + 8;
      if (id == 'fmt ' && body + 16 <= bytes.length) {
        formatTag = data.getUint16(body, Endian.little);
        channels = data.getUint16(body + 2, Endian.little);
        sampleRate = data.getUint32(body + 4, Endian.little);
        bits = data.getUint16(body + 14, Endian.little);
        // WAVE_FORMAT_EXTENSIBLE: the real format is in the sub-format GUID.
        if (formatTag == 0xFFFE && body + 26 <= bytes.length) {
          formatTag = data.getUint16(body + 24, Endian.little);
        }
      } else if (id == 'data') {
        dataOffset = body;
        dataLength = math.min(size, bytes.length - body);
        break;
      }
      offset = body + size + (size.isOdd ? 1 : 0);
    }

    if (formatTag == null ||
        channels == null ||
        channels == 0 ||
        sampleRate == null ||
        sampleRate == 0 ||
        bits == null ||
        dataOffset == null ||
        dataLength == null) {
      return null;
    }
    final isFloat = formatTag == 3;
    if (!(formatTag == 1 || isFloat) || ![8, 16, 24, 32].contains(bits)) {
      return null;
    }
    final bytesPerSample = bits ~/ 8;
    final frameSize = bytesPerSample * channels;
    final frames = dataLength ~/ frameSize;
    if (frames == 0) return (durationMs: 0, peaks: List.filled(peakCount, 0));

    double sampleAt(int position) => switch ((bits, isFloat)) {
      (32, true) => data.getFloat32(position, Endian.little),
      (8, _) => (data.getUint8(position) - 128) / 128,
      (16, _) => data.getInt16(position, Endian.little) / 32768,
      (24, _) =>
        (((data.getUint8(position + 2) << 24) |
                    (data.getUint8(position + 1) << 16) |
                    (data.getUint8(position) << 8)) >>
                8)
            .toSigned(24) /
            8388608,
      _ => data.getInt32(position, Endian.little) / 2147483648,
    };

    final peaks = List<double>.filled(peakCount, 0);
    final framesPerPeak = math.max(1, frames ~/ peakCount);
    // Sample a bounded number of frames per bucket to keep this fast.
    final stride = math.max(1, framesPerPeak ~/ 256);
    for (var p = 0; p < peakCount; p++) {
      final start = p * frames ~/ peakCount;
      final end = math.min(frames, (p + 1) * frames ~/ peakCount);
      var peak = 0.0;
      for (var f = start; f < end; f += stride) {
        final value = sampleAt(dataOffset + f * frameSize).abs();
        if (value > peak) peak = value;
      }
      peaks[p] = math.min(1, peak);
    }
    return (
      durationMs: (frames * 1000 / sampleRate).round(),
      peaks: peaks,
    );
  }
}
