import 'package:daw_music_maker/features/projects/presentation/widgets/genre_tags_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  Future<List<String>> pump(
    WidgetTester tester, {
    List<String> initial = const [],
  }) async {
    var genres = [...initial];
    await tester.pumpApp(
      StatefulBuilder(
        builder: (context, setState) => GenreTagsField(
          genres: genres,
          onChanged: (g) => setState(() => genres = g),
        ),
      ),
    );
    return genres;
  }

  group('Given a GenreTagsField', () {
    testWidgets('when typing and pressing Enter, then adds a trimmed tag', (
      tester,
    ) async {
      await pump(tester);

      await tester.enterText(find.byKey(GenreTagsField.inputKey), '  lo-fi ');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('#lo-fi'), findsOneWidget);
    });

    testWidgets('when typing a comma, then adds the tag before it', (
      tester,
    ) async {
      await pump(tester);

      await tester.enterText(find.byKey(GenreTagsField.inputKey), 'dub,');
      await tester.pump();

      expect(find.text('#dub'), findsOneWidget);
    });

    testWidgets('when 8 tags exist, then refuses another', (tester) async {
      await pump(tester, initial: List.generate(8, (i) => 'g$i'));

      await tester.enterText(find.byKey(GenreTagsField.inputKey), 'extra');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('Up to 8 genres'), findsOneWidget);
      expect(find.text('#extra'), findsNothing);
    });

    testWidgets('when removing a tag, then it disappears', (tester) async {
      await pump(tester, initial: ['jazz']);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(find.text('#jazz'), findsNothing);
    });

    testWidgets('when the server reported an error, then shows it', (
      tester,
    ) async {
      await tester.pumpApp(
        GenreTagsField(
          genres: const [],
          onChanged: (_) {},
          serverError: 'Too many genres',
        ),
      );

      expect(find.text('Too many genres'), findsOneWidget);
    });
  });
}
