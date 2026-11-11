import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_detail_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_form_view.dart';
import 'package:daw_music_maker/features/projects/presentation/views/projects_view.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/invitations_panel.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/invite_dialog.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/join_request_dialog.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/join_requests_panel.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/members_panel.dart';
import 'package:daw_music_maker/features/projects/presentation/widgets/role_selector.dart';
import 'package:daw_music_maker/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;

  final memberId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e61');
  final requestId = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e62',
  );

  final owner = ProjectMemberResponse(
    userId: otherTestId,
    email: 'owner@studio.fm',
    role: ProjectRole.write,
    isOwner: true,
    joinedAt: DateTime.utc(2026),
  );
  final member = ProjectMemberResponse(
    userId: memberId,
    email: 'bass@studio.fm',
    role: ProjectRole.read,
    isOwner: false,
    joinedAt: DateTime.utc(2026),
  );

  setUpAll(registerTestFallbacks);

  setUp(() {
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    stubEmptyProjectLists(projects);
    stubEmptyInbox(collab);
    when(
      () => collab.listMembers(any()),
    ).thenAnswer((_) async => [owner, member]);
    when(
      () => collab.listProjectInvitations(any()),
    ).thenAnswer((_) async => []);
    when(() => collab.listJoinRequests(any())).thenAnswer((_) async => []);
  });

  Future<void> open(WidgetTester tester, ProjectResponse project) async {
    when(() => projects.getById(project.id)).thenAnswer((_) async => project);
    await tester.pumpDawApp(
      session: FakeAuthSession(signedIn: true),
      projects: projects,
      collaboration: collab,
      initialLocation: '/projects/${project.id}',
    );
  }

  group('Given the owner of a project open to contributors', () {
    final project = testProject(
      visibility: ProjectVisibility.public,
      allowContributions: true,
      memberCount: 1,
    );

    testWidgets('when opened, then shows details, members and owner panels', (
      tester,
    ) async {
      await open(tester, project);

      expect(find.text(project.name), findsOneWidget);
      expect(find.text('owner@studio.fm'), findsOneWidget);
      expect(find.text('bass@studio.fm'), findsOneWidget);
      expect(find.byType(InvitationsPanel), findsOneWidget);
      expect(find.byType(JoinRequestsPanel), findsOneWidget);
      expect(find.byKey(ProjectDetailView.deleteKey), findsOneWidget);
      expect(find.byKey(ProjectDetailView.leaveKey), findsNothing);
    });

    testWidgets('when inviting by email, then sends the invitation', (
      tester,
    ) async {
      when(() => collab.invite(any(), any(), any())).thenAnswer(
        (_) async => ProjectInvitationResponse(
          id: requestId,
          projectId: project.id,
          projectName: project.name,
          email: 'keys@studio.fm',
          role: ProjectRole.write,
          createdAt: DateTime.utc(2026),
        ),
      );
      await open(tester, project);

      await tester.ensureVisible(find.byKey(InvitationsPanel.inviteKey));
      await tester.tap(find.byKey(InvitationsPanel.inviteKey));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(InviteDialog.emailFieldKey),
        'keys@studio.fm',
      );
      await tester.tap(find.byKey(RoleSelector.writeKey));
      await tester.tap(find.byKey(InviteDialog.sendKey));
      await tester.pumpAndSettle();

      verify(
        () => collab.invite(project.id, 'keys@studio.fm', ProjectRole.write),
      ).called(1);
      expect(find.byType(InviteDialog), findsNothing);
    });

    testWidgets('when the invite fails, then the dialog shows the error', (
      tester,
    ) async {
      when(() => collab.invite(any(), any(), any())).thenThrow(
        const Failure(
          FailureCode.conflict,
          fieldErrors: {'email': 'This person is already a member'},
        ),
      );
      await open(tester, project);

      await tester.ensureVisible(find.byKey(InvitationsPanel.inviteKey));
      await tester.tap(find.byKey(InvitationsPanel.inviteKey));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(InviteDialog.emailFieldKey),
        'bass@studio.fm',
      );
      await tester.tap(find.byKey(InviteDialog.sendKey));
      await tester.pumpAndSettle();

      expect(find.byType(InviteDialog), findsOneWidget);
      expect(find.text('This person is already a member'), findsOneWidget);
    });

    testWidgets('when accepting a join request, then responds to it', (
      tester,
    ) async {
      when(() => collab.listJoinRequests(any())).thenAnswer(
        (_) async => [
          JoinRequestResponse(
            id: requestId,
            projectId: project.id,
            projectName: project.name,
            userId: memberId,
            email: 'fan@studio.fm',
            role: ProjectRole.read,
            createdAt: DateTime.utc(2026),
          ),
        ],
      );
      when(
        () => collab.respondToJoinRequest(any(), accept: any(named: 'accept')),
      ).thenAnswer((_) async {});
      await open(tester, project);

      expect(find.text('fan@studio.fm'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(JoinRequestsPanel.acceptKey(requestId)),
      );
      await tester.tap(find.byKey(JoinRequestsPanel.acceptKey(requestId)));
      await tester.pumpAndSettle();

      verify(
        () => collab.respondToJoinRequest(requestId, accept: true),
      ).called(1);
    });

    testWidgets('when changing a member to write, then updates the role', (
      tester,
    ) async {
      when(
        () => collab.updateMemberRole(any(), any(), any()),
      ).thenAnswer((_) async => member);
      await open(tester, project);

      await tester.tap(find.byKey(MembersPanel.menuKey(memberId)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Give write access'));
      await tester.pumpAndSettle();

      verify(
        () => collab.updateMemberRole(project.id, memberId, ProjectRole.write),
      ).called(1);
    });

    testWidgets('when deleting and confirming, then returns to the list', (
      tester,
    ) async {
      when(() => projects.delete(any())).thenAnswer((_) async {});
      await open(tester, project);

      await tester.tap(find.byKey(ProjectDetailView.deleteKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(confirmDialogConfirmKey));
      await tester.pumpAndSettle();

      verify(() => projects.delete(project.id)).called(1);
      expect(find.byType(ProjectsView), findsOneWidget);
    });

    testWidgets('when tapping edit, then opens the edit form', (tester) async {
      await open(tester, project);

      await tester.tap(find.byKey(ProjectDetailView.editKey));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormView), findsOneWidget);
    });
  });

  group('Given a private project with contributions off', () {
    testWidgets('when the owner opens it, then inviting is disabled', (
      tester,
    ) async {
      await open(tester, testProject());

      expect(
        find.text('Turn on “Open to contributors” to invite people.'),
        findsOneWidget,
      );
      expect(find.byType(JoinRequestsPanel), findsNothing);
    });
  });

  group('Given a read member', () {
    final project = testProject(access: ProjectAccess.read, memberCount: 1);

    testWidgets('when opened, then can leave but not edit or manage', (
      tester,
    ) async {
      await open(tester, project);

      expect(find.byKey(ProjectDetailView.editKey), findsNothing);
      expect(find.byType(InvitationsPanel), findsNothing);
      expect(find.byKey(MembersPanel.menuKey(memberId)), findsNothing);
      verifyNever(() => collab.listProjectInvitations(any()));
    });

    testWidgets('when leaving and confirming, then returns to the list', (
      tester,
    ) async {
      when(() => collab.leave(any())).thenAnswer((_) async {});
      await open(tester, project);

      await tester.tap(find.byKey(ProjectDetailView.leaveKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(confirmDialogConfirmKey));
      await tester.pumpAndSettle();

      verify(() => collab.leave(project.id)).called(1);
      expect(find.byType(ProjectsView), findsOneWidget);
    });
  });

  group('Given a visitor of a public project open to contributors', () {
    final project = testProject(
      access: ProjectAccess.none,
      visibility: ProjectVisibility.public,
      allowContributions: true,
    );

    testWidgets('when requesting to join, then sends the chosen role', (
      tester,
    ) async {
      when(() => collab.requestToJoin(any(), any())).thenAnswer(
        (_) async => JoinRequestResponse(
          id: requestId,
          projectId: project.id,
          projectName: project.name,
          userId: memberId,
          email: 'me@studio.fm',
          role: ProjectRole.write,
          createdAt: DateTime.utc(2026),
        ),
      );
      await open(tester, project);

      expect(find.byKey(ProjectDetailView.editKey), findsNothing);
      verifyNever(() => collab.listMembers(any()));

      await tester.tap(find.byKey(ProjectDetailView.requestJoinKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(RoleSelector.writeKey));
      await tester.tap(find.byKey(joinRequestSendKey));
      await tester.pumpAndSettle();

      verify(
        () => collab.requestToJoin(project.id, ProjectRole.write),
      ).called(1);
    });

    testWidgets('when a request is pending, then offers to cancel it', (
      tester,
    ) async {
      final pending = testProject(
        access: ProjectAccess.none,
        visibility: ProjectVisibility.public,
        allowContributions: true,
        hasPendingJoinRequest: true,
      );
      when(collab.myJoinRequests).thenAnswer(
        (_) async => [
          JoinRequestResponse(
            id: requestId,
            projectId: pending.id,
            projectName: pending.name,
            userId: memberId,
            email: 'me@studio.fm',
            role: ProjectRole.read,
            createdAt: DateTime.utc(2026),
          ),
        ],
      );
      when(() => collab.cancelJoinRequest(any())).thenAnswer((_) async {});
      await open(tester, pending);

      await tester.tap(find.byKey(ProjectDetailView.cancelRequestKey));
      await tester.pumpAndSettle();

      verify(() => collab.cancelJoinRequest(requestId)).called(1);
    });
  });

  group('Given a project that is not visible', () {
    testWidgets('when opened, then shows not found', (tester) async {
      when(
        () => projects.getById(any()),
      ).thenThrow(const Failure(FailureCode.notFound));
      await tester.pumpDawApp(
        session: FakeAuthSession(signedIn: true),
        projects: projects,
        collaboration: collab,
        initialLocation: '/projects/$testRequestId',
      );

      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
}
