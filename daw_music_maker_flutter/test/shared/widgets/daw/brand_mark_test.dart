import 'package:daw_music_maker/shared/widgets/daw/brand_mark.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a BrandMark', () {
    testWidgets('when rendered, then shows the wordmark', (tester) async {
      await tester.pumpApp(const BrandMark());

      expect(find.text('DAW/MUSIC/MAKER'), findsOneWidget);
    });

    testWidgets('when the wordmark is hidden, then only the tile shows', (
      tester,
    ) async {
      await tester.pumpApp(const BrandMark(showWordmark: false));

      expect(find.text('DAW/MUSIC/MAKER'), findsNothing);
      expect(find.bySemanticsLabel('DAW Music Maker'), findsOneWidget);
    });
  });
}
