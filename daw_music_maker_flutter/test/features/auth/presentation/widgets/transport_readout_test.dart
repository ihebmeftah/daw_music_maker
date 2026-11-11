import 'package:daw_music_maker/features/auth/presentation/widgets/transport_readout.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('Given formatBarsBeatsTicks (960 PPQ, 4/4)', () {
    test('when at zero, then shows the first bar and beat', () {
      expect(formatBarsBeatsTicks(0), '001:1:000');
    });

    test('when one beat in, then advances the beat', () {
      expect(formatBarsBeatsTicks(960), '001:2:000');
    });

    test('when one bar in, then advances the bar', () {
      expect(formatBarsBeatsTicks(960 * 4), '002:1:000');
    });

    test('when mid-beat, then shows the remaining ticks', () {
      expect(formatBarsBeatsTicks(960 * 4 * 9 + 960 * 2 + 240), '010:3:240');
    });
  });

  group('Given a TransportReadout with reduced motion', () {
    testWidgets('when shown, then renders the tempo and start position', (
      tester,
    ) async {
      await tester.pumpApp(const TransportReadout(bpm: 140));

      expect(find.text('140.00'), findsOneWidget);
      expect(find.text('BPM'), findsOneWidget);
      expect(find.text('001:1:000'), findsOneWidget);
    });
  });
}
