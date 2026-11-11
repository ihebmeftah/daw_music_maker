import 'package:daw_music_maker_server/src/core/pagination/page_limits.dart';
import 'package:test/test.dart';

void main() {
  group('Given PageLimits.clampLimit', () {
    test('when null, then uses the default', () {
      expect(PageLimits.clampLimit(null), PageLimits.defaultLimit);
    });

    test('when out of range, then clamps to 1..max', () {
      expect(PageLimits.clampLimit(0), 1);
      expect(PageLimits.clampLimit(-5), 1);
      expect(PageLimits.clampLimit(1000), PageLimits.max);
    });

    test('when within range, then keeps it', () {
      expect(PageLimits.clampLimit(10), 10);
    });
  });

  group('Given PageLimits.clampOffset', () {
    test('when null or negative, then returns 0', () {
      expect(PageLimits.clampOffset(null), 0);
      expect(PageLimits.clampOffset(-3), 0);
    });

    test('when positive, then keeps it', () {
      expect(PageLimits.clampOffset(40), 40);
    });
  });
}
