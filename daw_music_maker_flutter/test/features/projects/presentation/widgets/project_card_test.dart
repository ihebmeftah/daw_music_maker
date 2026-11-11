import 'package:daw_music_maker/features/projects/presentation/widgets/project_card.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    ProjectResponse project, {
    VoidCallback? onTap,
    VoidCallback? onOpenStudio,
  }) => tester.pumpApp(
    Center(
      child: SizedBox(
        width: 360,
        height: 196,
        child: ProjectCard(
          project: project,
          onTap: onTap ?? () {},
          onOpenStudio: onOpenStudio ?? () {},
        ),
      ),
    ),
  );

  group('Given a ProjectCard', () {
    testWidgets('when tapping STUDIO, then opens the studio, not the page', (
      tester,
    ) async {
      var studio = 0;
      var page = 0;
      await pump(
        tester,
        testProject(),
        onTap: () => page++,
        onOpenStudio: () => studio++,
      );

      await tester.tap(find.byKey(ProjectCard.studioKey(testRequestId)));

      expect(studio, 1);
      expect(page, 0);
    });

    testWidgets('when rendered, then shows name, badges, genres and count', (
      tester,
    ) async {
      await pump(
        tester,
        testProject(
          name: 'Night Shift',
          genres: ['house', 'disco'],
          access: ProjectAccess.write,
          visibility: ProjectVisibility.public,
          memberCount: 2,
        ),
      );

      expect(find.text('Night Shift'), findsOneWidget);
      expect(find.text('WRITE'), findsOneWidget);
      expect(find.text('PUBLIC'), findsOneWidget);
      expect(find.text('#house'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('when the description is empty, then shows a placeholder', (
      tester,
    ) async {
      await pump(tester, testProject(description: ''));

      expect(find.text('No description yet.'), findsOneWidget);
    });

    testWidgets('when a join request is pending, then says REQUESTED', (
      tester,
    ) async {
      await pump(
        tester,
        testProject(access: ProjectAccess.none, hasPendingJoinRequest: true),
      );

      expect(find.text('REQUESTED'), findsOneWidget);
    });

    testWidgets('when hovered and tapped, then calls onTap', (tester) async {
      var taps = 0;
      await pump(tester, testProject(), onTap: () => taps++);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(ProjectCard)));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProjectCard));

      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  });
}
