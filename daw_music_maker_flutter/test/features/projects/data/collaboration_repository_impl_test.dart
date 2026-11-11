import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/collaboration_repository_impl.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

ProjectInvitationResponse _invitation() => ProjectInvitationResponse(
  id: otherTestId,
  projectId: testRequestId,
  projectName: 'Midnight Drive',
  email: 'friend@studio.fm',
  role: ProjectRole.write,
  createdAt: DateTime.utc(2026),
);

JoinRequestResponse _joinRequest() => JoinRequestResponse(
  id: otherTestId,
  projectId: testRequestId,
  projectName: 'Midnight Drive',
  userId: otherTestId,
  email: 'me@studio.fm',
  role: ProjectRole.read,
  createdAt: DateTime.utc(2026),
);

void main() {
  late MockEndpointProjectCollaboration endpoint;
  late CollaborationRepositoryImpl repository;

  setUpAll(() {
    registerTestFallbacks();
    registerFallbackValue(
      InviteMemberRequest(
        projectId: testRequestId,
        email: 'x@y.fm',
        role: ProjectRole.read,
      ),
    );
    registerFallbackValue(
      JoinProjectRequest(projectId: testRequestId, role: ProjectRole.read),
    );
    registerFallbackValue(
      UpdateMemberRoleRequest(
        projectId: testRequestId,
        userId: otherTestId,
        role: ProjectRole.read,
      ),
    );
  });

  setUp(() {
    endpoint = MockEndpointProjectCollaboration();
    repository = CollaborationRepositoryImpl(endpoint);
  });

  group('Given the CollaborationRepositoryImpl', () {
    test('when inviting, then trims and lower-cases the email', () async {
      when(() => endpoint.invite(any())).thenAnswer((_) async => _invitation());

      await repository.invite(
        testRequestId,
        '  Friend@Studio.FM ',
        ProjectRole.write,
      );

      final request =
          verify(() => endpoint.invite(captureAny())).captured.single
              as InviteMemberRequest;
      expect(request.projectId, testRequestId);
      expect(request.email, 'friend@studio.fm');
      expect(request.role, ProjectRole.write);
    });

    test('when requesting to join, then builds a JoinProjectRequest', () async {
      when(
        () => endpoint.requestToJoin(any()),
      ).thenAnswer((_) async => _joinRequest());

      await repository.requestToJoin(testRequestId, ProjectRole.write);

      final request =
          verify(() => endpoint.requestToJoin(captureAny())).captured.single
              as JoinProjectRequest;
      expect(request.projectId, testRequestId);
      expect(request.role, ProjectRole.write);
    });

    test(
      'when changing a role, then builds an UpdateMemberRoleRequest',
      () async {
        when(() => endpoint.updateMemberRole(any())).thenAnswer(
          (_) async => ProjectMemberResponse(
            userId: otherTestId,
            role: ProjectRole.write,
            isOwner: false,
            joinedAt: DateTime.utc(2026),
          ),
        );

        await repository.updateMemberRole(
          testRequestId,
          otherTestId,
          ProjectRole.write,
        );

        final request =
            verify(
                  () => endpoint.updateMemberRole(captureAny()),
                ).captured.single
                as UpdateMemberRoleRequest;
        expect(request.projectId, testRequestId);
        expect(request.userId, otherTestId);
        expect(request.role, ProjectRole.write);
      },
    );

    test('when responding, then passes the accept flag', () async {
      when(
        () => endpoint.respondToInvitation(any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => endpoint.respondToJoinRequest(any(), any()),
      ).thenAnswer((_) async {});

      await repository.respondToInvitation(otherTestId, accept: true);
      await repository.respondToJoinRequest(otherTestId, accept: false);

      verify(() => endpoint.respondToInvitation(otherTestId, true)).called(1);
      verify(() => endpoint.respondToJoinRequest(otherTestId, false)).called(1);
    });

    test('when managing members and invitations, then delegates ids', () async {
      when(() => endpoint.listMembers(any())).thenAnswer((_) async => []);
      when(() => endpoint.removeMember(any(), any())).thenAnswer((_) async {});
      when(() => endpoint.leave(any())).thenAnswer((_) async {});
      when(
        () => endpoint.listProjectInvitations(any()),
      ).thenAnswer((_) async => [_invitation()]);
      when(() => endpoint.cancelInvitation(any())).thenAnswer((_) async {});
      when(
        () => endpoint.listJoinRequests(any()),
      ).thenAnswer((_) async => [_joinRequest()]);
      when(() => endpoint.cancelJoinRequest(any())).thenAnswer((_) async {});
      when(endpoint.myInvitations).thenAnswer((_) async => [_invitation()]);
      when(endpoint.myJoinRequests).thenAnswer((_) async => [_joinRequest()]);

      await repository.listMembers(testRequestId);
      await repository.removeMember(testRequestId, otherTestId);
      await repository.leave(testRequestId);
      final invitations = await repository.listProjectInvitations(
        testRequestId,
      );
      await repository.cancelInvitation(otherTestId);
      final requests = await repository.listJoinRequests(testRequestId);
      await repository.cancelJoinRequest(otherTestId);
      final mine = await repository.myInvitations();
      final myRequests = await repository.myJoinRequests();

      verify(() => endpoint.listMembers(testRequestId)).called(1);
      verify(() => endpoint.removeMember(testRequestId, otherTestId)).called(1);
      verify(() => endpoint.leave(testRequestId)).called(1);
      verify(() => endpoint.cancelInvitation(otherTestId)).called(1);
      verify(() => endpoint.cancelJoinRequest(otherTestId)).called(1);
      expect(invitations, hasLength(1));
      expect(requests, hasLength(1));
      expect(mine, hasLength(1));
      expect(myRequests, hasLength(1));
    });

    test(
      'when inviting an existing member, then maps conflict with fieldErrors',
      () {
        when(() => endpoint.invite(any())).thenThrow(
          AppException(
            code: ErrorCode.conflict,
            fieldErrors: {'email': 'This person is already a member'},
          ),
        );

        expect(
          repository.invite(testRequestId, 'a@b.fm', ProjectRole.read),
          throwsA(
            isA<Failure>()
                .having((f) => f.code, 'code', FailureCode.conflict)
                .having(
                  (f) => f.fieldErrors,
                  'fieldErrors',
                  {'email': 'This person is already a member'},
                ),
          ),
        );
      },
    );

    test('when contributions are closed, then maps forbidden', () {
      when(
        () => endpoint.requestToJoin(any()),
      ).thenThrow(AppException(code: ErrorCode.forbidden));

      expect(
        repository.requestToJoin(testRequestId, ProjectRole.read),
        throwsA(const Failure(FailureCode.forbidden)),
      );
    });

    test('when offline, then maps network', () {
      when(
        endpoint.myInvitations,
      ).thenThrow(const ServerpodClientNetworkException('offline'));

      expect(
        repository.myInvitations(),
        throwsA(const Failure(FailureCode.network)),
      );
    });
  });
}
