import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/project_providers.dart';
import 'package:daw_music_maker/features/projects/presentation/view_models/project_detail_view_model.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

final _member = ProjectMemberResponse(
  userId: otherTestId,
  email: 'owner@studio.fm',
  role: ProjectRole.write,
  isOwner: true,
  joinedAt: DateTime.utc(2026),
);

final _invitation = ProjectInvitationResponse(
  id: otherTestId,
  projectId: testRequestId,
  projectName: 'Midnight Drive',
  email: 'friend@studio.fm',
  role: ProjectRole.read,
  createdAt: DateTime.utc(2026),
);

final _joinRequest = JoinRequestResponse(
  id: otherTestId,
  projectId: testRequestId,
  projectName: 'Midnight Drive',
  userId: otherTestId,
  email: 'fan@studio.fm',
  role: ProjectRole.read,
  createdAt: DateTime.utc(2026),
);

void main() {
  late MockProjectRepository projects;
  late MockCollaborationRepository collab;
  late ProviderContainer container;

  setUpAll(registerTestFallbacks);

  setUp(() {
    projects = MockProjectRepository();
    collab = MockCollaborationRepository();
    stubEmptyProjectLists(projects);
    stubEmptyInbox(collab);
    when(() => collab.listMembers(any())).thenAnswer((_) async => [_member]);
    when(
      () => collab.listProjectInvitations(any()),
    ).thenAnswer((_) async => [_invitation]);
    when(
      () => collab.listJoinRequests(any()),
    ).thenAnswer((_) async => [_joinRequest]);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        projectRepositoryProvider.overrideWithValue(projects),
        collaborationRepositoryProvider.overrideWithValue(collab),
      ],
    );
  });

  void stubProject(ProjectAccess access) {
    when(
      () => projects.getById(testRequestId),
    ).thenAnswer((_) async => testProject(access: access));
  }

  final provider = projectDetailViewModelProvider(testRequestId);

  Future<ProjectDetailViewModel> ready() async {
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    return container.read(provider.notifier);
  }

  group('Given the ProjectDetailViewModel loading', () {
    test(
      'when the user owns the project, then loads members, invitations and requests',
      () async {
        stubProject(ProjectAccess.owner);

        await ready();

        final state = container.read(provider).value!;
        expect(state.isOwner, isTrue);
        expect(state.members, [_member]);
        expect(state.invitations, [_invitation]);
        expect(state.joinRequests, [_joinRequest]);
      },
    );

    test('when the user is a member, then loads members only', () async {
      stubProject(ProjectAccess.write);

      await ready();

      final state = container.read(provider).value!;
      expect(state.isMember, isTrue);
      expect(state.canEdit, isTrue);
      expect(state.members, [_member]);
      expect(state.invitations, isEmpty);
      verifyNever(() => collab.listProjectInvitations(any()));
      verifyNever(() => collab.listJoinRequests(any()));
    });

    test('when the user is a visitor, then loads no members', () async {
      stubProject(ProjectAccess.none);

      await ready();

      expect(container.read(provider).value!.members, isEmpty);
      verifyNever(() => collab.listMembers(any()));
    });

    test('when the project is not visible, then fails with notFound', () async {
      when(
        () => projects.getById(testRequestId),
      ).thenThrow(const Failure(FailureCode.notFound));
      container.listen(provider, (_, _) {});

      await expectLater(
        container.read(provider.future),
        throwsA(isA<Failure>()),
      );
      expect(
        container.read(provider).error,
        const Failure(FailureCode.notFound),
      );
    });
  });

  group('Given the ProjectDetailViewModel actions', () {
    test('when inviting succeeds, then returns null and reloads', () async {
      stubProject(ProjectAccess.owner);
      when(
        () => collab.invite(testRequestId, 'a@b.fm', ProjectRole.write),
      ).thenAnswer((_) async => _invitation);
      final vm = await ready();

      final failure = await vm.invite('a@b.fm', ProjectRole.write);

      expect(failure, isNull);
      verify(() => projects.getById(testRequestId)).called(2);
      expect(container.read(provider).value!.isBusy, isFalse);
    });

    test(
      'when inviting fails, then returns the failure and sets actionFailure',
      () async {
        stubProject(ProjectAccess.owner);
        when(
          () => collab.invite(any(), any(), any()),
        ).thenThrow(const Failure(FailureCode.conflict));
        final vm = await ready();

        final failure = await vm.invite('a@b.fm', ProjectRole.read);

        expect(failure, const Failure(FailureCode.conflict));
        final state = container.read(provider).value!;
        expect(state.actionFailure, const Failure(FailureCode.conflict));
        expect(state.isBusy, isFalse);

        vm.clearActionFailure();
        expect(container.read(provider).value!.actionFailure, isNull);
      },
    );

    test(
      'when managing collaborators, then calls the matching repository methods',
      () async {
        stubProject(ProjectAccess.owner);
        when(
          () =>
              collab.respondToJoinRequest(any(), accept: any(named: 'accept')),
        ).thenAnswer((_) async {});
        when(
          () => collab.updateMemberRole(any(), any(), any()),
        ).thenAnswer((_) async => _member);
        when(() => collab.removeMember(any(), any())).thenAnswer((_) async {});
        when(() => collab.cancelInvitation(any())).thenAnswer((_) async {});
        final vm = await ready();

        await vm.respondToJoinRequest(otherTestId, accept: true);
        await vm.updateMemberRole(otherTestId, ProjectRole.read);
        await vm.removeMember(otherTestId);
        await vm.cancelInvitation(otherTestId);

        verify(
          () => collab.respondToJoinRequest(otherTestId, accept: true),
        ).called(1);
        verify(
          () => collab.updateMemberRole(
            testRequestId,
            otherTestId,
            ProjectRole.read,
          ),
        ).called(1);
        verify(() => collab.removeMember(testRequestId, otherTestId)).called(1);
        verify(() => collab.cancelInvitation(otherTestId)).called(1);
      },
    );

    test('when requesting to join, then sends the role', () async {
      stubProject(ProjectAccess.none);
      when(
        () => collab.requestToJoin(any(), any()),
      ).thenAnswer((_) async => _joinRequest);
      final vm = await ready();

      final failure = await vm.requestToJoin(ProjectRole.write);

      expect(failure, isNull);
      verify(
        () => collab.requestToJoin(testRequestId, ProjectRole.write),
      ).called(1);
    });

    test(
      'when cancelling a join request, then cancels the own request for this project',
      () async {
        stubProject(ProjectAccess.none);
        final other = JoinRequestResponse(
          id: testRequestId,
          projectId: otherTestId,
          projectName: 'Other',
          userId: otherTestId,
          role: ProjectRole.read,
          createdAt: DateTime.utc(2026),
        );
        when(
          collab.myJoinRequests,
        ).thenAnswer((_) async => [other, _joinRequest]);
        when(() => collab.cancelJoinRequest(any())).thenAnswer((_) async {});
        final vm = await ready();

        await vm.cancelJoinRequest();

        verify(() => collab.cancelJoinRequest(_joinRequest.id)).called(1);
        verifyNever(() => collab.cancelJoinRequest(other.id));
      },
    );

    test('when leaving or deleting, then succeeds without reloading', () async {
      stubProject(ProjectAccess.owner);
      when(() => collab.leave(any())).thenAnswer((_) async {});
      when(() => projects.delete(any())).thenAnswer((_) async {});
      final vm = await ready();

      expect(await vm.leave(), isNull);
      expect(await vm.deleteProject(), isNull);

      verify(() => collab.leave(testRequestId)).called(1);
      verify(() => projects.delete(testRequestId)).called(1);
      verify(() => projects.getById(testRequestId)).called(1);
    });
  });
}
