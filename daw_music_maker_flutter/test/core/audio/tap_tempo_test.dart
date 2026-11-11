import 'package:daw_music_maker/core/audio/tap_tempo.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given TapTempo', () {
    test('when tapped once, then no tempo yet', () {
      fakeAsync((async) {
        expect(TapTempo().tap(), isNull);
      });
    });

    test('when tapped every 500 ms, then reports 120 BPM', () {
      fakeAsync((async) {
        final tapTempo = TapTempo();
        double? bpm;
        for (var i = 0; i < 4; i++) {
          bpm = tapTempo.tap();
          async.elapse(const Duration(milliseconds: 500));
        }

        expect(bpm, closeTo(120, 0.001));
      });
    });

    test('when taps are uneven, then averages the recent intervals', () {
      fakeAsync((async) {
        final tapTempo = TapTempo();
        tapTempo.tap();
        async.elapse(const Duration(milliseconds: 400));
        tapTempo.tap();
        async.elapse(const Duration(milliseconds: 600));

        // Average interval 500 ms → 120 BPM.
        expect(tapTempo.tap(), closeTo(120, 0.001));
      });
    });

    test('when pausing longer than resetAfter, then starts over', () {
      fakeAsync((async) {
        final tapTempo = TapTempo();
        tapTempo.tap();
        async.elapse(const Duration(milliseconds: 500));
        tapTempo.tap();
        async.elapse(const Duration(seconds: 3));

        expect(tapTempo.tap(), isNull);
      });
    });

    test('when many taps happen, then only the last window counts', () {
      fakeAsync((async) {
        final tapTempo = TapTempo(window: 2);
        tapTempo.tap();
        async.elapse(const Duration(seconds: 1)); // 60 BPM, forgotten later
        tapTempo.tap();
        async.elapse(const Duration(milliseconds: 250));
        tapTempo.tap();
        async.elapse(const Duration(milliseconds: 250));

        expect(tapTempo.tap(), closeTo(240, 0.001));
      });
    });
  });
}
