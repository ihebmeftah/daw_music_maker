import 'package:daw_music_maker/core/audio/metronome.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAudioEngine engine;
  late Metronome metronome;

  setUp(() {
    engine = FakeAudioEngine();
    metronome = Metronome(engine);
  });

  group('Given Metronome.intervalFor', () {
    test('when at 120 BPM, then a beat lasts 500 ms', () {
      expect(Metronome.intervalFor(120), const Duration(milliseconds: 500));
    });

    test('when at 60 BPM, then a beat lasts 1 s', () {
      expect(Metronome.intervalFor(60), const Duration(seconds: 1));
    });
  });

  group('Given a running metronome', () {
    test(
      'when two bars pass at 120 BPM, then clicks 8 times, accents beat 1',
      () {
        fakeAsync((async) {
          metronome.start(120);
          async.flushMicrotasks();
          // Beat 1 plays immediately, then one beat every 500 ms.
          async.elapse(const Duration(milliseconds: 3500));

          expect(engine.loads, 1);
          expect(engine.clicks, [
            true,
            false,
            false,
            false,
            true,
            false,
            false,
            false,
          ]);
          expect(metronome.isRunning, isTrue);
          metronome.stop();
        });
      },
    );

    test('when playing, then beat reports the position in the bar', () {
      fakeAsync((async) {
        final beats = <int?>[];
        metronome.beat.addListener(() => beats.add(metronome.beat.value));
        metronome.start(240);
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 1250));

        expect(beats, [0, 1, 2, 3, 0, 1]);
        metronome.stop();
      });
    });

    test(
      'when the tempo changes, then the next beat follows the new tempo',
      () {
        fakeAsync((async) {
          metronome.start(60);
          async.flushMicrotasks();
          expect(engine.clicks, hasLength(1));

          async.elapse(const Duration(milliseconds: 100));
          metronome.bpm = 120;
          // Next beat is 500 ms after the last one (at t=500 ms), not 1 s.
          async.elapse(const Duration(milliseconds: 400));

          expect(engine.clicks, hasLength(2));
          metronome.stop();
        });
      },
    );

    test('when stopped, then clicks stop and the beat resets', () {
      fakeAsync((async) {
        metronome.start(120);
        async.flushMicrotasks();
        metronome.stop();
        async.elapse(const Duration(seconds: 2));

        expect(engine.clicks, hasLength(1));
        expect(metronome.beat.value, isNull);
        expect(metronome.isRunning, isFalse);
      });
    });

    test('when started twice, then plays a single stream of clicks', () {
      fakeAsync((async) {
        metronome.start(120);
        metronome.start(120);
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 600));

        expect(engine.clicks, hasLength(2));
        metronome.stop();
      });
    });

    test('when muted, then beats continue silently', () {
      fakeAsync((async) {
        final beats = <int?>[];
        metronome.beat.addListener(() => beats.add(metronome.beat.value));
        metronome.muted = true;
        metronome.start(120);
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 1100));
        metronome.muted = false;
        async.elapse(const Duration(milliseconds: 500));

        expect(beats, [0, 1, 2, 3]);
        expect(engine.clicks, [false]);
        metronome.stop();
      });
    });

    test('when playing, then reports elapsed time and beat position', () {
      fakeAsync((async) {
        expect(metronome.elapsed, Duration.zero);
        expect(metronome.beatPosition, 0);

        metronome.start(120);
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 1250));

        expect(metronome.elapsed, const Duration(milliseconds: 1250));
        // 1250 ms at 500 ms/beat = 2.5 beats.
        expect(metronome.beatPosition, closeTo(2.5, 1e-9));

        metronome.stop();
        expect(metronome.elapsed, Duration.zero);
        expect(metronome.beatPosition, 0);
      });
    });

    test('when stopped while loading, then never clicks', () {
      fakeAsync((async) {
        metronome.start(120);
        metronome.stop();
        async.flushMicrotasks();
        async.elapse(const Duration(seconds: 1));

        expect(engine.clicks, isEmpty);
      });
    });
  });
}
