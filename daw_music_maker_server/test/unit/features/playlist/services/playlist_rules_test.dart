import 'package:daw_music_maker_server/src/core/validation/validation_rules.dart';
import 'package:daw_music_maker_server/src/features/playlist/services/playlist_rules.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

void main() {
  final fourBars = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e01');
  final eightBars = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e02',
  );
  final unknown = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e03');
  final lengths = <Object, int>{fourBars: 4, eightBars: 8};

  ClipInput clip({UuidValue? pattern, int track = 0, int startBar = 0}) =>
      ClipInput(
        patternId: pattern ?? fourBars,
        track: track,
        startBar: startBar,
      );

  void validate(List<ClipInput> clips) =>
      PlaylistRules.validate(clips, patternLengths: lengths);

  Matcher throwsCode(ErrorCode code) =>
      throwsA(isA<AppException>().having((e) => e.code, 'code', code));

  Matcher throwsClipError(String text) => throwsA(
    isA<AppException>()
        .having((e) => e.code, 'code', ErrorCode.validation)
        .having((e) => e.fieldErrors?['clips'], 'clips', contains(text)),
  );

  group('Given PlaylistRules.validate', () {
    test('when the playlist is empty, then it is accepted', () {
      expect(() => validate([]), returnsNormally);
    });

    test('when a clip uses an unknown pattern, then validation fails', () {
      expect(
        () => validate([clip(pattern: unknown)]),
        throwsClipError('unknown pattern'),
      );
    });

    test('when the track is out of range, then validation fails', () {
      expect(
        () => validate([clip(track: -1)]),
        throwsCode(ErrorCode.validation),
      );
      expect(
        () => validate([clip(track: ValidationRules.playlistTracks)]),
        throwsCode(ErrorCode.validation),
      );
    });

    test('when the track is at a boundary, then it is accepted', () {
      expect(
        () => validate([clip(track: 0), clip(track: 15)]),
        returnsNormally,
      );
    });

    test('when the start bar is negative, then validation fails', () {
      expect(
        () => validate([clip(startBar: -1)]),
        throwsCode(ErrorCode.validation),
      );
    });

    test('when a clip ends past 256 bars, then validation fails', () {
      expect(
        () => validate([clip(startBar: 253)]),
        throwsClipError('256 bars'),
      );
    });

    test('when a clip ends exactly at 256 bars, then it is accepted', () {
      expect(() => validate([clip(startBar: 252)]), returnsNormally);
    });

    test('when clips partially overlap on a track, then validation fails', () {
      expect(
        () => validate([clip(startBar: 0), clip(startBar: 2)]),
        throwsClipError('overlaps'),
      );
    });

    test('when clips are identical, then validation fails', () {
      expect(
        () => validate([clip(startBar: 4), clip(startBar: 4)]),
        throwsClipError('overlaps'),
      );
    });

    test('when clips are adjacent, then they are accepted', () {
      expect(
        () => validate([clip(startBar: 0), clip(startBar: 4)]),
        returnsNormally,
      );
    });

    test('when clips share bars on different tracks, then accepted', () {
      expect(
        () => validate([clip(track: 0), clip(track: 1)]),
        returnsNormally,
      );
    });

    test('when overlap depends on pattern length, then it is detected', () {
      expect(
        () => validate([clip(pattern: eightBars), clip(startBar: 4)]),
        throwsClipError('overlaps'),
      );
    });

    test('when a clip is invalid, then the error names its index', () {
      expect(
        () => validate([clip(), clip(track: 1), clip(pattern: unknown)]),
        throwsClipError('Clip 3:'),
      );
    });

    test('when there are more than 2048 clips, then limitReached', () {
      final clips = [
        for (var i = 0; i <= ValidationRules.playlistClipsMax; i++)
          clip(track: i % 16, startBar: (i ~/ 16) * 4),
      ];
      expect(clips.length, 2049);
      expect(() => validate(clips), throwsCode(ErrorCode.limitReached));
    });
  });

  group('Given PlaylistRules.validate with audio clips', () {
    final sampleId = UuidValue.fromString(
      '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e10',
    );
    final otherSample = UuidValue.fromString(
      '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e11',
    );

    ClipInput audio({
      UuidValue? sample,
      int? lengthBars = 2,
      int track = 0,
      int startBar = 0,
    }) => ClipInput(
      sampleId: sample ?? sampleId,
      lengthBars: lengthBars,
      track: track,
      startBar: startBar,
    );

    void validateAudio(List<ClipInput> clips) => PlaylistRules.validate(
      clips,
      patternLengths: lengths,
      sampleIds: {sampleId},
    );

    test('when an audio clip is valid, then it is accepted', () {
      expect(() => validateAudio([audio(lengthBars: 64)]), returnsNormally);
    });

    test(
      'when a clip has both or neither a pattern and a sample, then fails',
      () {
        expect(
          () => validateAudio([
            ClipInput(
              patternId: fourBars,
              sampleId: sampleId,
              lengthBars: 2,
              track: 0,
              startBar: 0,
            ),
          ]),
          throwsClipError('exactly one'),
        );
        expect(
          () => validateAudio([ClipInput(track: 0, startBar: 0)]),
          throwsClipError('exactly one'),
        );
      },
    );

    test('when the sample is not the project\'s, then fails', () {
      expect(
        () => validateAudio([audio(sample: otherSample)]),
        throwsClipError('unknown sample'),
      );
    });

    test('when the audio length is missing or out of range, then fails', () {
      for (final bars in [null, 0, 65]) {
        expect(
          () => validateAudio([audio(lengthBars: bars)]),
          throwsClipError('audio length'),
          reason: '$bars',
        );
      }
    });

    test('when audio clips overlap by their length, then fails', () {
      expect(
        () => validateAudio([
          audio(lengthBars: 8),
          audio(lengthBars: 1, startBar: 7),
        ]),
        throwsClipError('overlaps'),
      );
      expect(
        () => validateAudio([audio(lengthBars: 8), audio(startBar: 8)]),
        returnsNormally,
      );
    });

    test('when an audio clip overlaps a pattern clip, then fails', () {
      expect(
        () => validateAudio([clip(), audio(startBar: 3)]),
        throwsClipError('overlaps'),
      );
    });

    test('when an audio clip ends past 256 bars, then fails', () {
      expect(
        () => validateAudio([audio(lengthBars: 4, startBar: 253)]),
        throwsClipError('256'),
      );
    });
  });
}
