import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/project_providers.dart';
import 'package:daw_music_maker/features/projects/presentation/view_models/inbox_view_model.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

final _invitation = ProjectInvitationResponse(
  id: otherTestId,
  projectId: testRequestId,
  projectName: 'Midnight Drive',
  email: 'me@studio.fm',
  role: ProjectRole.write,
  createdAt: DateTime.utc(2026),
);

final _request = JoinRequestResponse(
  id: testRequestId,
  projectId: otherTestId,
  projectName: 'Open Jam',
  userId: otherTestId,
  email: 'me@studio.fm',
  role: ProjectRole.read,
  createdAt: DateTime.utc(2026),
);

void main() {
  late MockCollaborationRepository collab;
  late ProviderContainer container;

  setUpAll(registerTestFallbacks);

  setUp(() {
    collab = MockCollaborationRepository();
    when(collab.myInvitations).thenAnswer((_) async => [_invitation]);
    when(collab.myJoinRequests).thenAnswer((_) async => [_request]);
    final projects = MockProjectRepository();
    stubEmptyProjectLists(projects);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        collaborationRepositoryProvider.overrideWithValue(collab),
        projectRepositoryProvider.overrideWithValue(projects),
      ],
    );
    container.listen(inboxViewModelProvider, (_, _) {});
  });

  Future<InboxViewModel> ready() async {
    await container.read(inboxViewModelProvider.future);
    return container.read(inboxViewModelProvider.notifier);
  }

  group('Given the InboxViewModel', () {
    test('when built, then loads invitations and join requests', () async {
      await ready();

      final state = container.read(inboxViewModelProvider).value!;
      expect(state.invitations, [_invitation]);
      expect(state.joinRequests, [_request]);
    });

    test('when accepting an invitation, then responds and reloads', () async {
      when(
        () => collab.respondToInvitation(any(), accept: any(named: 'accept')),
      ).thenAnswer((_) async {});
      final vm = await ready();
      when(collab.myInvitations).thenAnswer((_) async => []);

      await vm.respondToInvitation(otherTestId, accept: true);

      verify(
        () => collab.respondToInvitation(otherTestId, accept: true),
      ).called(1);
      final state = container.read(inboxViewModelProvider).value!;
      expect(state.invitations, isEmpty);
      expect(state.isBusy, isFalse);
    });

    test(
      'when declining an invitation, then responds with accept false',
      () async {
        when(
          () => collab.respondToInvitation(any(), accept: any(named: 'accept')),
        ).thenAnswer((_) async {});
        final vm = await ready();

        await vm.respondToInvitation(otherTestId, accept: false);

        verify(
          () => collab.respondToInvitation(otherTestId, accept: false),
        ).called(1);
      },
    );

    test('when cancelling a join request, then cancels it', () async {
      when(() => collab.cancelJoinRequest(any())).thenAnswer((_) async {});
      final vm = await ready();

      await vm.cancelJoinRequest(testRequestId);

      verify(() => collab.cancelJoinRequest(testRequestId)).called(1);
    });

    test(
      'when an action fails, then stores the failure and keeps the lists',
      () async {
        when(
          () => collab.respondToInvitation(any(), accept: any(named: 'accept')),
        ).thenThrow(const Failure(FailureCode.notFound));
        final vm = await ready();

        await vm.respondToInvitation(otherTestId, accept: true);

        final state = container.read(inboxViewModelProvider).value!;
        expect(state.actionFailure, const Failure(FailureCode.notFound));
        expect(state.invitations, [_invitation]);
        expect(state.isBusy, isFalse);

        vm.clearActionFailure();
        expect(
          container.read(inboxViewModelProvider).value!.actionFailure,
          isNull,
        );
      },
    );

    test('when loading fails, then exposes an AsyncError', () async {
      when(collab.myInvitations).thenThrow(const Failure(FailureCode.network));
      container.invalidate(inboxViewModelProvider);

      await expectLater(
        container.read(inboxViewModelProvider.future),
        throwsA(const Failure(FailureCode.network)),
      );
    });
  });
}
