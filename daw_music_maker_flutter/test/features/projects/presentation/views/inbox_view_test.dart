import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/presentation/views/inbox_view.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;

  final invitationId = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e70',
  );
  final requestId = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e71',
  );

  final invitation = ProjectInvitationResponse(
    id: invitationId,
    projectId: testRequestId,
    projectName: 'Collab Session',
    email: 'me@studio.fm',
    role: ProjectRole.write,
    createdAt: DateTime.utc(2026),
  );
  final request = JoinRequestResponse(
    id: requestId,
    projectId: otherTestId,
    projectName: 'Open Jam',
    userId: testRequestId,
    email: 'me@studio.fm',
    role: ProjectRole.read,
    createdAt: DateTime.utc(2026),
  );

  setUpAll(registerTestFallbacks);

  setUp(() {
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    stubEmptyProjectLists(projects);
    when(collab.myInvitations).thenAnswer((_) async => [invitation]);
    when(collab.myJoinRequests).thenAnswer((_) async => [request]);
    when(
      () => collab.respondToInvitation(any(), accept: any(named: 'accept')),
    ).thenAnswer((_) async {});
    when(() => collab.cancelJoinRequest(any())).thenAnswer((_) async {});
  });

  Future<void> open(WidgetTester tester) => tester.pumpDawApp(
    session: FakeAuthSession(signedIn: true),
    projects: projects,
    collaboration: collab,
    initialLocation: '/inbox',
  );

  group('Given the inbox', () {
    testWidgets('when opened, then lists invitations and sent requests', (
      tester,
    ) async {
      await open(tester);

      expect(find.byType(InboxView), findsOneWidget);
      expect(find.text('Collab Session'), findsOneWidget);
      expect(find.text('Invites you with write access'), findsOneWidget);
      expect(find.text('Open Jam'), findsOneWidget);
    });

    testWidgets('when accepting an invitation, then responds with accept', (
      tester,
    ) async {
      await open(tester);
      when(collab.myInvitations).thenAnswer((_) async => []);

      await tester.tap(find.byKey(InboxView.acceptKey(invitationId)));
      await tester.pumpAndSettle();

      verify(
        () => collab.respondToInvitation(invitationId, accept: true),
      ).called(1);
      expect(find.text('Collab Session'), findsNothing);
    });

    testWidgets('when declining an invitation, then responds with decline', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(InboxView.declineKey(invitationId)));
      await tester.pumpAndSettle();

      verify(
        () => collab.respondToInvitation(invitationId, accept: false),
      ).called(1);
    });

    testWidgets('when cancelling a sent request, then cancels it', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(InboxView.cancelRequestKey(requestId)));
      await tester.pumpAndSettle();

      verify(() => collab.cancelJoinRequest(requestId)).called(1);
    });

    testWidgets('when an action fails, then shows the error', (tester) async {
      when(
        () => collab.respondToInvitation(any(), accept: any(named: 'accept')),
      ).thenThrow(const Failure(FailureCode.notFound));
      await open(tester);

      await tester.tap(find.byKey(InboxView.acceptKey(invitationId)));
      await tester.pumpAndSettle();

      expect(find.text(FailureCode.notFound.message), findsOneWidget);
    });

    testWidgets('when empty, then explains where items come from', (
      tester,
    ) async {
      when(collab.myInvitations).thenAnswer((_) async => []);
      when(collab.myJoinRequests).thenAnswer((_) async => []);

      await open(tester);

      expect(find.text('No invitations'), findsOneWidget);
      expect(find.text('No pending requests'), findsOneWidget);
    });
  });
}
