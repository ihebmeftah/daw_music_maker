import 'package:daw_music_maker_server/src/features/channels/services/channel_rules.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

Matcher _validationOn(Set<String> fields) => throwsA(
  isA<AppException>()
      .having((e) => e.code, 'code', ErrorCode.validation)
      .having((e) => e.fieldErrors?.keys.toSet(), 'fields', fields),
);

void main() {
  group('Given ChannelRules.validate', () {
    test('when valid, then trims the name and keeps the volume', () {
      final result = ChannelRules.validate(name: '  Kick  ', volume: 0.5);

      expect(result.name, 'Kick');
      expect(result.volume, 0.5);
    });

    test('when the name is blank, then a name error is thrown', () {
      expect(
        () => ChannelRules.validate(name: '   ', volume: 0.5),
        _validationOn({'name'}),
      );
    });

    test('when the name has 41 characters, then a name error is thrown', () {
      expect(
        () => ChannelRules.validate(name: 'a' * 41, volume: 0.5),
        _validationOn({'name'}),
      );
    });

    test('when the name has 40 characters, then it is accepted', () {
      expect(
        ChannelRules.validate(name: 'a' * 40, volume: 0.5).name.length,
        40,
      );
    });

    test(
      'when the volume is out of range or NaN, then a volume error is thrown',
      () {
        for (final volume in [-0.1, 1.1, double.nan, double.infinity]) {
          expect(
            () => ChannelRules.validate(name: 'Kick', volume: volume),
            _validationOn({'volume'}),
            reason: '$volume',
          );
        }
      },
    );

    test('when the volume is at a boundary, then it is accepted', () {
      expect(ChannelRules.validate(name: 'Kick', volume: 0).volume, 0);
      expect(ChannelRules.validate(name: 'Kick', volume: 1).volume, 1);
    });

    test('when both fields are invalid, then both errors are reported', () {
      expect(
        () => ChannelRules.validate(name: '', volume: 2),
        _validationOn({'name', 'volume'}),
      );
    });
  });

  group('Given ChannelRules.defaultName', () {
    test('when given each sample, then returns its display name', () {
      expect(ChannelRules.defaultName(SampleKind.kick), 'Kick');
      expect(ChannelRules.defaultName(SampleKind.snare), 'Snare');
      expect(ChannelRules.defaultName(SampleKind.closedHat), 'Hat');
      expect(ChannelRules.defaultName(SampleKind.openHat), 'Open Hat');
    });
  });

  group('Given ChannelRules.defaults', () {
    test('when read, then lists Kick, Snare, Hat, Open Hat in order', () {
      expect(ChannelRules.defaults, [
        ('Kick', SampleKind.kick),
        ('Snare', SampleKind.snare),
        ('Hat', SampleKind.closedHat),
        ('Open Hat', SampleKind.openHat),
      ]);
    });
  });

  group('Given ChannelRules.validate sampler settings', () {
    void check({
      double pan = 0,
      int pitch = 0,
      double startFrac = 0,
      double endFrac = 1,
    }) => ChannelRules.validate(
      name: 'Kick',
      volume: 0.5,
      pan: pan,
      pitch: pitch,
      startFrac: startFrac,
      endFrac: endFrac,
    );

    test('when pan is at ±1, then it is accepted', () {
      expect(() => check(pan: -1), returnsNormally);
      expect(() => check(pan: 1), returnsNormally);
    });

    test('when pan is beyond ±1 or not finite, then a pan error', () {
      expect(() => check(pan: 1.01), _validationOn({'pan'}));
      expect(() => check(pan: -1.01), _validationOn({'pan'}));
      expect(() => check(pan: double.nan), _validationOn({'pan'}));
    });

    test('when pitch is at ±24, then it is accepted', () {
      expect(() => check(pitch: 24), returnsNormally);
      expect(() => check(pitch: -24), returnsNormally);
    });

    test('when pitch is beyond ±24, then a pitch error', () {
      expect(() => check(pitch: 25), _validationOn({'pitch'}));
      expect(() => check(pitch: -25), _validationOn({'pitch'}));
    });

    test('when the region is at least 0.001 wide, then it is accepted', () {
      expect(() => check(startFrac: 0.25, endFrac: 0.251), returnsNormally);
      expect(() => check(startFrac: 0, endFrac: 1), returnsNormally);
    });

    test(
      'when the region is empty, reversed or outside, then a region error',
      () {
        expect(
          () => check(startFrac: 0.5, endFrac: 0.5),
          _validationOn({'region'}),
        );
        expect(
          () => check(startFrac: 0.5, endFrac: 0.5005),
          _validationOn({'region'}),
        );
        expect(
          () => check(startFrac: 0.8, endFrac: 0.2),
          _validationOn({'region'}),
        );
        expect(() => check(startFrac: -0.1), _validationOn({'region'}));
        expect(() => check(endFrac: 1.1), _validationOn({'region'}));
        expect(
          () => check(startFrac: double.nan),
          _validationOn({'region'}),
        );
      },
    );

    test('when several settings are invalid, then all errors are reported', () {
      expect(
        () => check(pan: 2, pitch: 30, startFrac: 1, endFrac: 0),
        _validationOn({'pan', 'pitch', 'region'}),
      );
    });
  });

  group('Given ChannelRules.slices', () {
    test('when slicing the whole sample in 4, then equal contiguous parts', () {
      final slices = ChannelRules.slices(0, 1, 4);

      expect(slices, [(0.0, 0.25), (0.25, 0.5), (0.5, 0.75), (0.75, 1.0)]);
    });

    test(
      'when slicing a region, then the slices cover exactly that region',
      () {
        final slices = ChannelRules.slices(0.1, 0.7, 16);

        expect(slices, hasLength(16));
        expect(slices.first.$1, 0.1);
        expect(slices.last.$2, 0.7);
        for (var i = 1; i < slices.length; i++) {
          expect(slices[i].$1, slices[i - 1].$2);
          expect(slices[i].$2 - slices[i].$1, closeTo(0.6 / 16, 1e-12));
        }
      },
    );
  });
}
