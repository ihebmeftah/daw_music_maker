import 'package:daw_music_maker_server/src/features/patterns/services/pattern_rules.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

Pattern _pattern(String name, int position) => Pattern(
  projectId: UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e5f'),
  name: name,
  position: position,
);

Matcher _validationOn(Set<String> fields) => throwsA(
  isA<AppException>()
      .having((e) => e.code, 'code', ErrorCode.validation)
      .having((e) => e.fieldErrors?.keys.toSet(), 'fields', fields),
);

void main() {
  group('Given PatternRules.validate', () {
    test('when valid, then trims the name and keeps the values', () {
      final result = PatternRules.validate(
        name: '  Drums  ',
        colorIndex: 3,
        lengthBars: 8,
      );

      expect(result.name, 'Drums');
      expect(result.colorIndex, 3);
      expect(result.lengthBars, 8);
    });

    test('when the name is blank, then a name error is thrown', () {
      expect(
        () => PatternRules.validate(name: '   ', colorIndex: 0, lengthBars: 4),
        _validationOn({'name'}),
      );
    });

    test('when the name has 40 chars, then it is accepted', () {
      final result = PatternRules.validate(
        name: 'a' * 40,
        colorIndex: 0,
        lengthBars: 4,
      );
      expect(result.name, hasLength(40));
    });

    test('when the name has 41 chars, then a name error is thrown', () {
      expect(
        () =>
            PatternRules.validate(name: 'a' * 41, colorIndex: 0, lengthBars: 4),
        _validationOn({'name'}),
      );
    });

    test('when colorIndex is -1 or 8, then a colorIndex error is thrown', () {
      for (final color in [-1, 8]) {
        expect(
          () => PatternRules.validate(
            name: 'P',
            colorIndex: color,
            lengthBars: 4,
          ),
          _validationOn({'colorIndex'}),
          reason: '$color',
        );
      }
    });

    test('when colorIndex is 0 or 7, then it is accepted', () {
      for (final color in [0, 7]) {
        expect(
          PatternRules.validate(
            name: 'P',
            colorIndex: color,
            lengthBars: 4,
          ).colorIndex,
          color,
        );
      }
    });

    test('when lengthBars is 0 or 17, then a lengthBars error is thrown', () {
      for (final bars in [0, 17]) {
        expect(
          () =>
              PatternRules.validate(name: 'P', colorIndex: 0, lengthBars: bars),
          _validationOn({'lengthBars'}),
          reason: '$bars',
        );
      }
    });

    test('when lengthBars is 1 or 16, then it is accepted', () {
      for (final bars in [1, 16]) {
        expect(
          PatternRules.validate(
            name: 'P',
            colorIndex: 0,
            lengthBars: bars,
          ).lengthBars,
          bars,
        );
      }
    });

    test('when several fields are invalid, then all errors are reported', () {
      expect(
        () => PatternRules.validate(name: '', colorIndex: 9, lengthBars: 0),
        _validationOn({'name', 'colorIndex', 'lengthBars'}),
      );
    });
  });

  group('Given PatternRules.nextPosition', () {
    test('when there are no patterns, then returns 0', () {
      expect(PatternRules.nextPosition([]), 0);
    });

    test('when positions have gaps, then returns max + 1', () {
      expect(
        PatternRules.nextPosition([
          _pattern('a', 0),
          _pattern('b', 5),
          _pattern('c', 2),
        ]),
        6,
      );
    });
  });

  group('Given PatternRules.defaultName', () {
    test('when there are no patterns, then returns Pattern 1', () {
      expect(PatternRules.defaultName([]), 'Pattern 1');
    });

    test(
      'when "Pattern N" names exist, then returns one above the highest',
      () {
        expect(
          PatternRules.defaultName([
            _pattern('Pattern 1', 0),
            _pattern('Pattern 7', 1),
            _pattern('Pattern 3', 2),
          ]),
          'Pattern 8',
        );
      },
    );

    test('when other names exist, then they are ignored', () {
      expect(
        PatternRules.defaultName([
          _pattern('Pattern 2', 0),
          _pattern('Pattern 99 copy', 1),
          _pattern('Drums', 2),
        ]),
        'Pattern 3',
      );
    });

    test('when no name matches, then falls back to count + 1', () {
      expect(
        PatternRules.defaultName([_pattern('Drums', 0), _pattern('Bass', 1)]),
        'Pattern 3',
      );
    });
  });

  group('Given PatternRules.defaultColor', () {
    test('when adding patterns, then cycles through the 8 colors', () {
      List<Pattern> n(int count) => [
        for (var i = 0; i < count; i++) _pattern('p$i', i),
      ];

      expect(PatternRules.defaultColor(n(0)), 0);
      expect(PatternRules.defaultColor(n(3)), 3);
      expect(PatternRules.defaultColor(n(8)), 0);
      expect(PatternRules.defaultColor(n(9)), 1);
    });
  });

  group('Given PatternRules.cloneName', () {
    test('when the name is short, then appends " (copy)"', () {
      expect(PatternRules.cloneName('Drums'), 'Drums (copy)');
    });

    test('when the name is long, then the result is capped at 40', () {
      final name = PatternRules.cloneName('a' * 40);

      expect(name, hasLength(40));
      expect(name, endsWith(' (copy)'));
    });
  });

  group('Given PatternRules.lengthTicks', () {
    test('when given bars, then returns 3840 ticks per bar', () {
      expect(PatternRules.lengthTicks(1), 3840);
      expect(PatternRules.lengthTicks(4), 15360);
    });
  });

  group('Given PatternRules.validateNotes', () {
    final channel = UuidValue.fromString(
      '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e70',
    );
    final stranger = UuidValue.fromString(
      '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e71',
    );
    const patternTicks = 3840;

    NoteInput note({
      UuidValue? channelId,
      int tick = 0,
      int lengthTicks = 240,
      int pitch = 60,
      int velocity = 100,
    }) => NoteInput(
      channelId: channelId ?? channel,
      tick: tick,
      lengthTicks: lengthTicks,
      pitch: pitch,
      velocity: velocity,
    );

    void check(List<NoteInput> notes) => PatternRules.validateNotes(
      notes,
      patternTicks: patternTicks,
      channelIds: {channel},
    );

    test('when every note is valid, then nothing is thrown', () {
      expect(
        () => check([note(), note(tick: 240, pitch: 64)]),
        returnsNormally,
      );
    });

    test('when the list is empty, then nothing is thrown', () {
      expect(() => check([]), returnsNormally);
    });

    test('when boundary values are used, then they are accepted', () {
      expect(
        () => check([
          note(tick: 0, pitch: 0, velocity: 1, lengthTicks: 1),
          note(tick: 3839, lengthTicks: 1, pitch: 127, velocity: 127),
          note(tick: 0, lengthTicks: patternTicks),
        ]),
        returnsNormally,
      );
    });

    test('when a note uses an unknown channel, then validation fails', () {
      expect(
        () => check([note(channelId: stranger)]),
        _validationOn({'notes'}),
      );
    });

    test(
      'when a note starts before 0 or at the end, then validation fails',
      () {
        for (final tick in [-1, patternTicks]) {
          expect(
            () => check([note(tick: tick, lengthTicks: 1)]),
            _validationOn({'notes'}),
            reason: '$tick',
          );
        }
      },
    );

    test(
      'when a note has length 0 or overflows the end, then validation fails',
      () {
        expect(() => check([note(lengthTicks: 0)]), _validationOn({'notes'}));
        expect(
          () => check([note(tick: 3800, lengthTicks: 41)]),
          _validationOn({'notes'}),
        );
      },
    );

    test('when the pitch is outside 0–127, then validation fails', () {
      for (final pitch in [-1, 128]) {
        expect(
          () => check([note(pitch: pitch)]),
          _validationOn({'notes'}),
          reason: '$pitch',
        );
      }
    });

    test('when the velocity is outside 1–127, then validation fails', () {
      for (final velocity in [0, 128]) {
        expect(
          () => check([note(velocity: velocity)]),
          _validationOn({'notes'}),
          reason: '$velocity',
        );
      }
    });

    test('when a later note is invalid, then the error names its position', () {
      expect(
        () => check([note(), note(pitch: 200)]),
        throwsA(
          isA<AppException>().having(
            (e) => e.fieldErrors?['notes'],
            'notes error',
            startsWith('Note 2:'),
          ),
        ),
      );
    });

    test(
      'when there are more than 4096 notes, then limitReached is thrown',
      () {
        expect(
          () => check(List.generate(4097, (_) => note())),
          throwsA(
            isA<AppException>().having(
              (e) => e.code,
              'code',
              ErrorCode.limitReached,
            ),
          ),
        );
      },
    );

    test('when there are exactly 4096 notes, then they are accepted', () {
      expect(() => check(List.generate(4096, (_) => note())), returnsNormally);
    });
  });
}
