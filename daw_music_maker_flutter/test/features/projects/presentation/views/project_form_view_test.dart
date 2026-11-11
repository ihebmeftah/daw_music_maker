import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_detail_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_form_view.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/genre_tags_field.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;

  setUpAll(registerTestFallbacks);

  setUp(() {
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    stubEmptyProjectLists(projects);
    stubEmptyInbox(collab);
    when(() => collab.listMembers(any())).thenAnswer((_) async => []);
    when(
      () => collab.listProjectInvitations(any()),
    ).thenAnswer((_) async => []);
    when(() => collab.listJoinRequests(any())).thenAnswer((_) async => []);
  });

  Future<void> open(WidgetTester tester, String location) => tester.pumpDawApp(
    session: FakeAuthSession(signedIn: true),
    projects: projects,
    collaboration: collab,
    initialLocation: location,
  );

  Future<void> addGenre(WidgetTester tester, String genre) async {
    await tester.enterText(find.byKey(GenreTagsField.inputKey), genre);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  group('Given the new project form', () {
    testWidgets('when saving without a name, then shows a field error', (
      tester,
    ) async {
      await open(tester, '/projects/new');

      await tester.ensureVisible(find.byKey(ProjectFormView.saveKey));
      await tester.tap(find.byKey(ProjectFormView.saveKey));
      await tester.pumpAndSettle();

      expect(find.text('Give your project a name'), findsOneWidget);
      verifyNever(() => projects.create(any()));
    });

    testWidgets('when adding a duplicate genre, then rejects it', (
      tester,
    ) async {
      await open(tester, '/projects/new');

      await addGenre(tester, 'Techno');
      await addGenre(tester, 'techno');

      expect(find.text('#Techno'), findsOneWidget);
      expect(find.text('Already added'), findsOneWidget);
    });

    testWidgets(
      'when the form is valid, then creates the project and opens it',
      (tester) async {
        final created = testProject(
          name: 'Night Shift',
          visibility: ProjectVisibility.public,
          allowContributions: true,
        );
        when(() => projects.create(any())).thenAnswer((_) async => created);
        when(
          () => projects.getById(created.id),
        ).thenAnswer((_) async => created);
        await open(tester, '/projects/new');

        await tester.enterText(
          find.byKey(ProjectFormView.nameFieldKey),
          '  Night Shift ',
        );
        await tester.enterText(
          find.byKey(ProjectFormView.descriptionFieldKey),
          'Late-night house',
        );
        await addGenre(tester, 'house');
        await tester.ensureVisible(find.byKey(ProjectFormView.publicKey));
        await tester.tap(find.byKey(ProjectFormView.publicKey));
        await tester.tap(find.byKey(ProjectFormView.contributionsKey));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(ProjectFormView.saveKey));
        await tester.tap(find.byKey(ProjectFormView.saveKey));
        await tester.pumpAndSettle();

        final request =
            verify(() => projects.create(captureAny())).captured.single
                as CreateProjectRequest;
        expect(request.name, 'Night Shift');
        expect(request.description, 'Late-night house');
        expect(request.genres, ['house']);
        expect(request.visibility, ProjectVisibility.public);
        expect(request.allowContributions, isTrue);
        expect(find.byType(ProjectDetailView), findsOneWidget);
      },
    );

    testWidgets('when the server rejects a field, then shows its message', (
      tester,
    ) async {
      when(() => projects.create(any())).thenThrow(
        const Failure(
          FailureCode.validation,
          fieldErrors: {'name': 'Name is taken by the server'},
        ),
      );
      await open(tester, '/projects/new');

      await tester.enterText(find.byKey(ProjectFormView.nameFieldKey), 'Dup');
      await tester.ensureVisible(find.byKey(ProjectFormView.saveKey));
      await tester.tap(find.byKey(ProjectFormView.saveKey));
      await tester.pumpAndSettle();

      expect(find.text('Name is taken by the server'), findsOneWidget);
      expect(find.text(FailureCode.validation.message), findsOneWidget);
    });
  });

  group('Given the edit form', () {
    testWidgets(
      'when opened by the owner, then shows current values and saves',
      (
        tester,
      ) async {
        final project = testProject(name: 'Old Name', genres: ['dub']);
        when(
          () => projects.getById(project.id),
        ).thenAnswer((_) async => project);
        when(
          () => projects.update(any(), any()),
        ).thenAnswer((_) async => project);
        await open(tester, '/projects/${project.id}/edit');

        expect(find.text('Old Name'), findsOneWidget);
        expect(find.text('#dub'), findsOneWidget);

        await tester.enterText(
          find.byKey(ProjectFormView.nameFieldKey),
          'New Name',
        );
        await tester.ensureVisible(find.byKey(ProjectFormView.saveKey));
        await tester.tap(find.byKey(ProjectFormView.saveKey));
        await tester.pumpAndSettle();

        final request =
            verify(
                  () => projects.update(project.id, captureAny()),
                ).captured.single
                as UpdateProjectRequest;
        expect(request.name, 'New Name');
        expect(request.genres, ['dub']);
      },
    );

    testWidgets('when opened by a write member, then sharing is locked', (
      tester,
    ) async {
      final project = testProject(access: ProjectAccess.write);
      when(() => projects.getById(project.id)).thenAnswer((_) async => project);
      await open(tester, '/projects/${project.id}/edit');

      expect(
        find.text('Only the owner can change sharing settings.'),
        findsOneWidget,
      );
    });

    testWidgets('when the id in the URL is not a UUID, then shows not found', (
      tester,
    ) async {
      await open(tester, '/projects/not-a-uuid/edit');

      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
}
