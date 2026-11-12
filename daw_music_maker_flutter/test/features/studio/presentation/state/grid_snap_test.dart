import 'package:daw_music_maker/features/studio/presentation/state/grid_snap.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given GridSnap', () {
    test('when reading sizes, then matches FL Studio at PPQ 960', () {
      expect(GridSnap.values.map((s) => s.ticks), [3840, 960, 480, 240, 120]);
      expect(GridSnap.values.map((s) => s.steps), [16, 4, 2, 1, 1]);
      expect(GridSnap.values.map((s) => s.label), [
        'Bar',
        'Beat',
        '½ beat',
        'Step',
        'Line',
      ]);
    });

    test('when listing playlist options, then Line is not offered', () {
      expect(GridSnap.playlistOptions, isNot(contains(GridSnap.line)));
    });

    test('when snapping down, then floors to the grid', () {
      expect(GridSnap.snapDown(0, 4), 0);
      expect(GridSnap.snapDown(7, 4), 4);
      expect(GridSnap.snapDown(8, 4), 8);
      expect(GridSnap.snapDown(1000, 960), 960);
    });
  });
}
