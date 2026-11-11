import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/projects/presentation/state/project_list_state.dart';
import 'package:daw_music_maker/features/projects/presentation/views/inbox_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_detail_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_form_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/project_card.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/project_list_body.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late FakeAuthSession session;
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;

  setUpAll(registerTestFallbacks);

  setUp(() {
    session = FakeAuthSession(signedIn: true);
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    stubEmptyProjectLists(projects);
    stubEmptyInbox(collab);
  });

  Future<void> pump(WidgetTester tester) => tester.pumpDawApp(
    session: session,
    projects: projects,
    collaboration: collab,
  );

  group('Given the projects screen', () {
    testWidgets('when the user has no projects, then shows the empty state', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byType(ProjectsView), findsOneWidget);
      expect(find.text('No projects yet'), findsOneWidget);
    });

    testWidgets('when the user has projects, then shows a card for each', (
      tester,
    ) async {
      when(
        () => projects.listMine(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => ProjectPageResponse(
          items: [
            testProject(name: 'Midnight Drive'),
            testProject(id: otherTestId, name: 'Basement Tapes'),
          ],
          hasMore: false,
        ),
      );

      await pump(tester);

      expect(find.byType(ProjectCard), findsNWidgets(2));
      expect(find.text('Midnight Drive'), findsOneWidget);
      expect(find.text('Basement Tapes'), findsOneWidget);
    });

    testWidgets('when more pages exist, then "Load more" fetches the next', (
      tester,
    ) async {
      when(
        () => projects.listMine(limit: any(named: 'limit'), offset: 0),
      ).thenAnswer(
        (_) async => ProjectPageResponse(items: [testProject()], hasMore: true),
      );
      when(
        () => projects.listMine(limit: any(named: 'limit'), offset: 1),
      ).thenAnswer(
        (_) async => ProjectPageResponse(
          items: [testProject(id: otherTestId, name: 'Page Two')],
          hasMore: false,
        ),
      );
      await pump(tester);

      await tester.tap(find.byKey(ProjectListBody.loadMoreKey));
      await tester.pumpAndSettle();

      expect(find.text('Page Two'), findsOneWidget);
      expect(find.byKey(ProjectListBody.loadMoreKey), findsNothing);
    });

    testWidgets('when loading fails, then shows an error with retry', (
      tester,
    ) async {
      when(
        () => projects.listMine(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenThrow(const Failure(FailureCode.network));
      await pump(tester);

      expect(find.text(FailureCode.network.message), findsOneWidget);

      stubEmptyProjectLists(projects);
      await tester.tap(find.text('TRY AGAIN'));
      await tester.pumpAndSettle();

      expect(find.text('No projects yet'), findsOneWidget);
    });

    testWidgets('when switching to Discover and searching, then filters', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(
        find.byKey(ProjectsView.tabKey(ProjectListKind.discover)),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ProjectsView.searchKey), 'lofi');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      verify(
        () => projects.discover(
          query: 'lofi',
          limit: any(named: 'limit'),
          offset: 0,
        ),
      ).called(1);
      expect(find.text('No matches'), findsOneWidget);
    });

    testWidgets('when switching to Shared, then loads shared projects', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(ProjectsView.tabKey(ProjectListKind.shared)));
      await tester.pumpAndSettle();

      expect(find.text('Nothing shared yet'), findsOneWidget);
    });

    testWidgets('when tapping "New project", then opens the form', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(ProjectsView.newProjectKey));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormView), findsOneWidget);
    });

    testWidgets('when tapping a card, then opens the project', (tester) async {
      final project = testProject(
        access: ProjectAccess.none,
        visibility: ProjectVisibility.public,
      );
      when(
        () => projects.listMine(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => ProjectPageResponse(items: [project], hasMore: false),
      );
      when(() => projects.getById(project.id)).thenAnswer((_) async => project);
      await pump(tester);

      await tester.tap(find.byType(ProjectCard));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailView), findsOneWidget);
    });

    testWidgets('when invitations are pending, then the inbox shows a badge', (
      tester,
    ) async {
      when(collab.myInvitations).thenAnswer(
        (_) async => [
          ProjectInvitationResponse(
            id: otherTestId,
            projectId: testRequestId,
            projectName: 'Collab',
            email: 'me@studio.fm',
            role: ProjectRole.write,
            createdAt: DateTime.utc(2026),
          ),
        ],
      );
      await pump(tester);

      expect(
        find.descendant(
          of: find.byKey(ProjectsView.inboxKey),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(ProjectsView.inboxKey));
      await tester.pumpAndSettle();
      expect(find.byType(InboxView), findsOneWidget);
    });

    testWidgets('when signing out, then returns to the login screen', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(ProjectsView.signOutKey));
      await tester.pumpAndSettle();

      expect(session.signOutCalls, 1);
      expect(find.byType(LoginView), findsOneWidget);
    });

    testWidgets('when on a phone, then the layout does not overflow', (
      tester,
    ) async {
      await pump(tester);
      tester.view.physicalSize = const Size(360, 780);
      await tester.pumpAndSettle();

      expect(find.byType(ProjectsView), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.byType(Badge), findsOneWidget);
    });
  });
}
