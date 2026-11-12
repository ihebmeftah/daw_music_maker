import 'package:daw_music_maker/features/auth/presentation/views/login_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/inbox_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_detail_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_form_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/project_card.dart';
import 'package:daw_music_maker/features/studio/presentation/views/studio_view.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/transport_toolbar.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

/// The browser URL must always match the screen (deep links, refresh,
/// sharing), including across sign-in.
void main() {
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;
  late MockStudioRepository studio;
  final project = testProject();
  final id = project.id.toString();

  setUpAll(registerTestFallbacks);

  setUp(() {
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    studio = MockStudioRepository();
    stubEmptyInbox(collab);
    when(
      () => projects.listMine(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (_) async => ProjectPageResponse(items: [project], hasMore: false),
    );
    when(() => projects.getById(any())).thenAnswer((_) async => project);
    when(() => collab.listMembers(any())).thenAnswer((_) async => []);
    when(
      () => collab.listProjectInvitations(any()),
    ).thenAnswer((_) async => []);
    when(() => collab.listJoinRequests(any())).thenAnswer((_) async => []);
    when(() => studio.loadProject(any())).thenAnswer((_) async => project);
    stubPatterns(studio);
  });

  Future<ProviderContainerHandle> open(
    WidgetTester tester, {
    FakeAuthSession? session,
    MockAuthRepository? auth,
    String? location,
  }) async {
    final container = await tester.pumpDawApp(
      session: session ?? FakeAuthSession(signedIn: true),
      repository: auth,
      projects: projects,
      collaboration: collab,
      studio: studio,
      initialLocation: location,
    );
    return ProviderContainerHandle(container);
  }

  group('Given a signed-in user navigating from the project list', () {
    testWidgets('when opening a card, then the URL is /projects/<id>', (
      tester,
    ) async {
      final app = await open(tester);

      await tester.tap(find.byType(ProjectCard));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailView), findsOneWidget);
      expect(app.location, '/projects/$id');
    });

    testWidgets(
      'when tapping a card STUDIO button, then the URL is the studio',
      (
        tester,
      ) async {
        final app = await open(tester);

        await tester.tap(find.byKey(ProjectCard.studioKey(project.id)));
        await tester.pumpAndSettle();

        expect(find.byType(StudioView), findsOneWidget);
        expect(app.location, '/projects/$id/studio');

        // Back returns to the project page.
        await tester.tap(find.byKey(TransportToolbar.backKey));
        await tester.pumpAndSettle();
        expect(app.location, '/projects/$id');
      },
    );

    testWidgets('when tapping New project, then the URL is /projects/form', (
      tester,
    ) async {
      final app = await open(tester);

      await tester.tap(find.byKey(ProjectsView.newProjectKey));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormView), findsOneWidget);
      expect(app.location, '/projects/form');
    });

    testWidgets('when opening the inbox and going back, then URLs follow', (
      tester,
    ) async {
      final app = await open(tester);

      await tester.tap(find.byKey(ProjectsView.inboxKey));
      await tester.pumpAndSettle();
      expect(find.byType(InboxView), findsOneWidget);
      expect(app.location, '/inbox');

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectsView), findsOneWidget);
      expect(app.location, '/projects');
    });
  });

  group('Given a signed-in user on a project page', () {
    testWidgets('when going to the studio, then the URL is the studio', (
      tester,
    ) async {
      final app = await open(tester, location: '/projects/$id');

      await tester.tap(find.byKey(ProjectDetailView.studioKey));
      await tester.pumpAndSettle();

      expect(app.location, '/projects/$id/studio');
    });

    testWidgets('when editing, then the URL is /projects/form?id=<id>', (
      tester,
    ) async {
      final app = await open(tester, location: '/projects/$id');

      await tester.tap(find.byKey(ProjectDetailView.editKey));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectFormView), findsOneWidget);
      expect(app.location, '/projects/form?id=$id');

      // Back from editing returns to the project, not the list.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(app.location, '/projects/$id');
    });
  });

  group('Given a signed-out user opening a deep link', () {
    testWidgets('when signing in, then returns to the requested studio', (
      tester,
    ) async {
      final session = FakeAuthSession();
      final auth = MockAuthRepository();
      when(
        () => auth.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => session.signIn());
      final app = await open(
        tester,
        session: session,
        auth: auth,
        location: '/projects/$id/studio',
      );

      expect(find.byType(LoginView), findsOneWidget);
      expect(Uri.parse(app.location).path, '/login');
      expect(
        Uri.parse(app.location).queryParameters['from'],
        '/projects/$id/studio',
      );

      await tester.enterText(
        find.byKey(LoginView.emailFieldKey),
        'producer@studio.fm',
      );
      await tester.enterText(
        find.byKey(LoginView.passwordFieldKey),
        'secret123',
      );
      await tester.tap(find.byKey(LoginView.submitKey));
      await tester.pumpAndSettle();

      expect(find.byType(StudioView), findsOneWidget);
      expect(app.location, '/projects/$id/studio');
    });

    testWidgets('when the app opens at /, then lands on the login page', (
      tester,
    ) async {
      final app = await open(
        tester,
        session: FakeAuthSession(),
        location: '/',
      );

      expect(app.location, '/login');
    });
  });
}

/// Small wrapper to read the current router location in assertions.
class ProviderContainerHandle {
  /// Wraps [container].
  ProviderContainerHandle(this.container);

  /// The app's provider container.
  final ProviderContainer container;

  /// What the browser URL shows.
  String get location => currentLocation(container);
}
