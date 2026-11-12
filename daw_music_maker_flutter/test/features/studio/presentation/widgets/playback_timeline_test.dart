import 'package:daw_music_maker/core/audio/transport_position.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/playback_timeline.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

/// Controllable [TransportPosition] for painting tests.
class _FakePosition implements TransportPosition {
  @override
  bool isRunning = false;

  @override
  Duration elapsed = Duration.zero;

  @override
  double beatPosition = 0;
}

void main() {
  group('Given formatElapsed', () {
    test('when zero, then shows 00:00.00', () {
      expect(formatElapsed(Duration.zero), '00:00.00');
    });

    test('when over a minute, then shows minutes, seconds, hundredths', () {
      expect(
        formatElapsed(
          const Duration(minutes: 1, seconds: 7, milliseconds: 259),
        ),
        '01:07.25',
      );
    });
  });

  group('Given formatBarBeat', () {
    test('when at the start, then bar 1 beat 1', () {
      expect(formatBarBeat(0), 'BAR 1 · BEAT 1');
    });

    test('when 5.5 beats in, then bar 2 beat 2', () {
      expect(formatBarBeat(5.5), 'BAR 2 · BEAT 2');
    });
  });

  group('Given a PlaybackTimeline', () {
    late _FakePosition position;

    setUp(() => position = _FakePosition());

    Future<void> pump(WidgetTester tester, {required bool playing}) =>
        tester.pumpApp(
          PlaybackTimeline(
            position: position,
            isPlaying: playing,
            hits: const [],
          ),
        );

    testWidgets('when rendered, then label, position and time share one row', (
      tester,
    ) async {
      await pump(tester, playing: false);

      final label = tester.getCenter(find.text('TIMELINE · LOOP 4 BARS')).dy;
      final position = tester
          .getCenter(
            find.byKey(PlaybackTimeline.barBeatKey),
          )
          .dy;
      final time = tester.getCenter(find.byKey(PlaybackTimeline.elapsedKey));

      expect(position, closeTo(label, 1));
      expect(time.dy, closeTo(label, 1));
      expect(
        tester.getCenter(find.byKey(PlaybackTimeline.elapsedKey)).dx,
        greaterThan(tester.getCenter(find.text('TIMELINE · LOOP 4 BARS')).dx),
      );
    });

    testWidgets('when narrow, then the header row does not overflow', (
      tester,
    ) async {
      await tester.pumpApp(
        Center(
          child: SizedBox(
            width: 300,
            child: PlaybackTimeline(
              position: position,
              isPlaying: false,
              hits: const [],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('when stopped, then shows zero time and STOPPED', (
      tester,
    ) async {
      await pump(tester, playing: false);

      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.text('STOPPED'), findsOneWidget);
      expect(find.text('TIMELINE · LOOP 4 BARS'), findsOneWidget);
    });

    testWidgets('when playing, then updates time and position every frame', (
      tester,
    ) async {
      position
        ..isRunning = true
        ..elapsed = const Duration(seconds: 3, milliseconds: 500)
        ..beatPosition = 7.2;
      await pump(tester, playing: true);
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text('00:03.50'), findsOneWidget);
      expect(find.text('BAR 2 · BEAT 4'), findsOneWidget);

      position
        ..elapsed = const Duration(seconds: 4)
        ..beatPosition = 8;
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text('00:04.00'), findsOneWidget);
      expect(find.text('BAR 3 · BEAT 1'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Stop the ticker before the test ends.
      await tester.pumpApp(
        PlaybackTimeline(position: position, isPlaying: false, hits: const []),
      );
    });

    testWidgets('when the position passes the loop end, then paints wrapped', (
      tester,
    ) async {
      position
        ..isRunning = true
        ..beatPosition = 37.5; // loop of 16 beats → 5.5 in the loop
      await pump(tester, playing: true);
      await tester.pump(const Duration(milliseconds: 16));

      expect(tester.takeException(), isNull);
      await tester.pumpApp(
        PlaybackTimeline(position: position, isPlaying: false, hits: const []),
      );
    });
  });
}
