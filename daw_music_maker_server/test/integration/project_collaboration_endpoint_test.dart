import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the ProjectCollaboration endpoint', (
    sessionBuilder,
    endpoints,
  ) {
    late TestUser owner;
    late TestUser alice;
    late TestUser bob;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );
    final missingId = UuidValue.fromString(
      '0190f1c2-7b7a-7cc0-8d4e-000000000000',
    );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      alice = await createUser(sessionBuilder, uniqueEmail('alice'));
      bob = await createUser(sessionBuilder, uniqueEmail('bob'));
    });

    Future<ProjectResponse> create({
      ProjectVisibility visibility = ProjectVisibility.private,
      bool allowContributions = true,
    }) => endpoints.project.create(
      owner.session,
      createRequest(
        visibility: visibility,
        allowContributions: allowContributions,
      ),
    );

    Future<ProjectResponse> openPublic() =>
        create(visibility: ProjectVisibility.public);

    Future<void> addMember(
      ProjectResponse project,
      TestUser user, [
      ProjectRole role = ProjectRole.read,
    ]) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    Future<ProjectInvitationResponse> invite(
      ProjectResponse project,
      String email, [
      ProjectRole role = ProjectRole.write,
    ]) => endpoints.projectCollaboration.invite(
      owner.session,
      InviteMemberRequest(projectId: project.id, email: email, role: role),
    );

    Future<JoinRequestResponse> requestJoin(
      ProjectResponse project,
      TestUser user, [
      ProjectRole role = ProjectRole.read,
    ]) => endpoints.projectCollaboration.requestToJoin(
      user.session,
      JoinProjectRequest(projectId: project.id, role: role),
    );

    group('listMembers', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.listMembers(
            unauthenticated,
            project.id,
          ),
          throwsUnauthenticated,
        );
      });

      test(
        "when listing another user's private project, then notFound",
        () async {
          final project = await create();
          await expectLater(
            endpoints.projectCollaboration.listMembers(
              alice.session,
              project.id,
            ),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test(
        'when a non-member views a public project, then forbidden',
        () async {
          final project = await openPublic();
          await expectLater(
            endpoints.projectCollaboration.listMembers(
              alice.session,
              project.id,
            ),
            throwsAppException(ErrorCode.forbidden),
          );
        },
      );

      test(
        'when a member lists, then the owner comes first with emails',
        () async {
          final project = await create();
          await addMember(project, alice, ProjectRole.write);

          final members = await endpoints.projectCollaboration.listMembers(
            alice.session,
            project.id,
          );

          expect(members, hasLength(2));
          expect(members.first.isOwner, isTrue);
          expect(members.first.email, owner.email);
          expect(members.last.userId, alice.id);
          expect(members.last.email, alice.email);
          expect(members.last.role, ProjectRole.write);
        },
      );
    });

    group('updateMemberRole', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.updateMemberRole(
            unauthenticated,
            UpdateMemberRoleRequest(
              projectId: project.id,
              userId: alice.id,
              role: ProjectRole.write,
            ),
          ),
          throwsUnauthenticated,
        );
      });

      test("when not the owner, then notFound / forbidden", () async {
        final project = await create();
        final request = UpdateMemberRoleRequest(
          projectId: project.id,
          userId: alice.id,
          role: ProjectRole.write,
        );
        await expectLater(
          endpoints.projectCollaboration.updateMemberRole(bob.session, request),
          throwsAppException(ErrorCode.notFound),
        );
        await addMember(project, bob, ProjectRole.write);
        await expectLater(
          endpoints.projectCollaboration.updateMemberRole(bob.session, request),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the user is not a member, then notFound', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.updateMemberRole(
            owner.session,
            UpdateMemberRoleRequest(
              projectId: project.id,
              userId: alice.id,
              role: ProjectRole.write,
            ),
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the owner changes a role, then it is updated', () async {
        final project = await create();
        await addMember(project, alice, ProjectRole.read);

        final updated = await endpoints.projectCollaboration.updateMemberRole(
          owner.session,
          UpdateMemberRoleRequest(
            projectId: project.id,
            userId: alice.id,
            role: ProjectRole.write,
          ),
        );

        expect(updated.role, ProjectRole.write);
        expect(updated.email, alice.email);
      });
    });

    group('removeMember', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.removeMember(
            unauthenticated,
            project.id,
            alice.id,
          ),
          throwsUnauthenticated,
        );
      });

      test("when not the owner, then notFound", () async {
        final project = await create();
        await addMember(project, alice);
        await expectLater(
          endpoints.projectCollaboration.removeMember(
            bob.session,
            project.id,
            alice.id,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the owner removes a member, then they lose access', () async {
        final project = await create();
        await addMember(project, alice);

        await endpoints.projectCollaboration.removeMember(
          owner.session,
          project.id,
          alice.id,
        );

        await expectLater(
          endpoints.project.getById(alice.session, project.id),
          throwsAppException(ErrorCode.notFound),
        );
      });
    });

    group('leave', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.leave(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test("when not a member of a private project, then notFound", () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.leave(alice.session, project.id),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the owner leaves, then conflict', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.leave(owner.session, project.id),
          throwsAppException(ErrorCode.conflict),
        );
      });

      test('when a member leaves, then the membership is removed', () async {
        final project = await create();
        await addMember(project, alice);

        await endpoints.projectCollaboration.leave(alice.session, project.id);

        final page = await endpoints.project.listShared(alice.session);
        expect(page.items, isEmpty);
      });
    });

    group('invite', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.invite(
            unauthenticated,
            InviteMemberRequest(
              projectId: project.id,
              email: alice.email,
              role: ProjectRole.read,
            ),
          ),
          throwsUnauthenticated,
        );
      });

      test(
        "when inviting to another user's private project, then notFound",
        () async {
          final project = await create();
          await expectLater(
            endpoints.projectCollaboration.invite(
              alice.session,
              InviteMemberRequest(
                projectId: project.id,
                email: bob.email,
                role: ProjectRole.read,
              ),
            ),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a member (not owner) invites, then forbidden', () async {
        final project = await create();
        await addMember(project, alice, ProjectRole.write);
        await expectLater(
          endpoints.projectCollaboration.invite(
            alice.session,
            InviteMemberRequest(
              projectId: project.id,
              email: bob.email,
              role: ProjectRole.read,
            ),
          ),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when contributions are disabled, then forbidden', () async {
        final project = await create(allowContributions: false);
        await expectLater(
          invite(project, alice.email),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test(
        'when the email is invalid, then a validation error is thrown',
        () async {
          final project = await create();
          await expectLater(
            invite(project, 'not-an-email'),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when inviting the own email, then a validation error is thrown',
        () async {
          final project = await create();
          await expectLater(
            invite(project, owner.email.toUpperCase()),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test('when the email belongs to a member, then conflict', () async {
        final project = await create();
        await addMember(project, alice);
        await expectLater(
          invite(project, alice.email),
          throwsAppException(ErrorCode.conflict),
        );
      });

      test(
        'when re-inviting the same email, then the role is updated',
        () async {
          final project = await create();
          await invite(project, alice.email, ProjectRole.read);

          final again = await invite(
            project,
            ' ${alice.email.toUpperCase()} ',
            ProjectRole.write,
          );

          final pending = await endpoints.projectCollaboration
              .listProjectInvitations(owner.session, project.id);
          expect(pending, hasLength(1));
          expect(again.role, ProjectRole.write);
          expect(again.email, alice.email);
        },
      );

      test(
        'when the email has no account, then it still succeeds and works after sign-up',
        () async {
          final project = await create();
          final email = uniqueEmail('future');

          final invitation = await invite(project, email, ProjectRole.write);
          expect(invitation.email, email);
          expect(invitation.projectName, project.name);

          final newcomer = await createUser(sessionBuilder, email);
          final inbox = await endpoints.projectCollaboration.myInvitations(
            newcomer.session,
          );
          expect(inbox.map((i) => i.id), [invitation.id]);

          await endpoints.projectCollaboration.respondToInvitation(
            newcomer.session,
            invitation.id,
            true,
          );
          final seen = await endpoints.project.getById(
            newcomer.session,
            project.id,
          );
          expect(seen.access, ProjectAccess.write);
        },
      );
    });

    group('listProjectInvitations', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.listProjectInvitations(
            unauthenticated,
            project.id,
          ),
          throwsUnauthenticated,
        );
      });

      test("when listing another user's project, then notFound", () async {
        final project = await create();
        await expectLater(
          endpoints.projectCollaboration.listProjectInvitations(
            alice.session,
            project.id,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test(
        'when the owner lists, then pending invitations are returned',
        () async {
          final project = await create();
          await invite(project, alice.email);
          await invite(project, bob.email);

          final pending = await endpoints.projectCollaboration
              .listProjectInvitations(owner.session, project.id);

          expect(pending.map((i) => i.email).toSet(), {alice.email, bob.email});
        },
      );
    });

    group('cancelInvitation', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        final invitation = await invite(project, alice.email);
        await expectLater(
          endpoints.projectCollaboration.cancelInvitation(
            unauthenticated,
            invitation.id,
          ),
          throwsUnauthenticated,
        );
      });

      test('when not the owner (even the invitee), then notFound', () async {
        final project = await create();
        final invitation = await invite(project, alice.email);
        await expectLater(
          endpoints.projectCollaboration.cancelInvitation(
            alice.session,
            invitation.id,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the invitation does not exist, then notFound', () async {
        await expectLater(
          endpoints.projectCollaboration.cancelInvitation(
            owner.session,
            missingId,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test(
        'when the owner cancels, then it disappears from the inbox',
        () async {
          final project = await create();
          final invitation = await invite(project, alice.email);

          await endpoints.projectCollaboration.cancelInvitation(
            owner.session,
            invitation.id,
          );

          final inbox = await endpoints.projectCollaboration.myInvitations(
            alice.session,
          );
          expect(inbox, isEmpty);
        },
      );
    });

    group('myInvitations', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.projectCollaboration.myInvitations(unauthenticated),
          throwsUnauthenticated,
        );
      });

      test(
        "when listing, then only invitations for the caller's email are shown",
        () async {
          final project = await create();
          final forAlice = await invite(project, alice.email);
          await invite(project, bob.email);

          final inbox = await endpoints.projectCollaboration.myInvitations(
            alice.session,
          );

          expect(inbox.map((i) => i.id), [forAlice.id]);
          expect(inbox.single.projectName, project.name);
        },
      );
    });

    group('respondToInvitation', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create();
        final invitation = await invite(project, alice.email);
        await expectLater(
          endpoints.projectCollaboration.respondToInvitation(
            unauthenticated,
            invitation.id,
            true,
          ),
          throwsUnauthenticated,
        );
      });

      test(
        "when responding to someone else's invitation, then notFound",
        () async {
          final project = await create();
          final invitation = await invite(project, alice.email);
          await expectLater(
            endpoints.projectCollaboration.respondToInvitation(
              bob.session,
              invitation.id,
              true,
            ),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test(
        'when accepting, then the invitee becomes a member with the role',
        () async {
          final project = await create();
          final invitation = await invite(
            project,
            alice.email,
            ProjectRole.read,
          );

          await endpoints.projectCollaboration.respondToInvitation(
            alice.session,
            invitation.id,
            true,
          );

          final seen = await endpoints.project.getById(
            alice.session,
            project.id,
          );
          expect(seen.access, ProjectAccess.read);
          expect(
            await endpoints.projectCollaboration.myInvitations(alice.session),
            isEmpty,
          );
        },
      );

      test(
        'when declining, then the invitation is deleted without membership',
        () async {
          final project = await create();
          final invitation = await invite(project, alice.email);

          await endpoints.projectCollaboration.respondToInvitation(
            alice.session,
            invitation.id,
            false,
          );

          await expectLater(
            endpoints.project.getById(alice.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
          expect(
            await endpoints.projectCollaboration.listProjectInvitations(
              owner.session,
              project.id,
            ),
            isEmpty,
          );
        },
      );
    });

    group('requestToJoin', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await openPublic();
        await expectLater(
          endpoints.projectCollaboration.requestToJoin(
            unauthenticated,
            JoinProjectRequest(projectId: project.id, role: ProjectRole.read),
          ),
          throwsUnauthenticated,
        );
      });

      test('when the project is private, then notFound', () async {
        final project = await create();
        await expectLater(
          requestJoin(project, alice),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test(
        'when the public project is closed to contributions, then forbidden',
        () async {
          final project = await create(
            visibility: ProjectVisibility.public,
            allowContributions: false,
          );
          await expectLater(
            requestJoin(project, alice),
            throwsAppException(ErrorCode.forbidden),
          );
        },
      );

      test('when already a member or owner, then conflict', () async {
        final project = await openPublic();
        await addMember(project, alice);
        await expectLater(
          requestJoin(project, alice),
          throwsAppException(ErrorCode.conflict),
        );
        await expectLater(
          requestJoin(project, owner),
          throwsAppException(ErrorCode.conflict),
        );
      });

      test(
        'when requesting, then it is pending and re-requesting updates the role',
        () async {
          final project = await openPublic();

          final first = await requestJoin(project, alice, ProjectRole.read);
          final again = await requestJoin(project, alice, ProjectRole.write);

          expect(again.id, first.id);
          expect(again.role, ProjectRole.write);
          expect(again.email, alice.email);
          final seen = await endpoints.project.getById(
            alice.session,
            project.id,
          );
          expect(seen.hasPendingJoinRequest, isTrue);
        },
      );
    });

    group('cancelJoinRequest', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);
        await expectLater(
          endpoints.projectCollaboration.cancelJoinRequest(
            unauthenticated,
            request.id,
          ),
          throwsUnauthenticated,
        );
      });

      test("when cancelling someone else's request, then notFound", () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);
        await expectLater(
          endpoints.projectCollaboration.cancelJoinRequest(
            bob.session,
            request.id,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the requester cancels, then it is removed', () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);

        await endpoints.projectCollaboration.cancelJoinRequest(
          alice.session,
          request.id,
        );

        expect(
          await endpoints.projectCollaboration.myJoinRequests(alice.session),
          isEmpty,
        );
      });
    });

    group('myJoinRequests', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.projectCollaboration.myJoinRequests(unauthenticated),
          throwsUnauthenticated,
        );
      });

      test("when listing, then only the caller's requests are shown", () async {
        final project = await openPublic();
        final mine = await requestJoin(project, alice);
        await requestJoin(project, bob);

        final requests = await endpoints.projectCollaboration.myJoinRequests(
          alice.session,
        );

        expect(requests.map((r) => r.id), [mine.id]);
        expect(requests.single.projectName, project.name);
      });
    });

    group('listJoinRequests', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await openPublic();
        await expectLater(
          endpoints.projectCollaboration.listJoinRequests(
            unauthenticated,
            project.id,
          ),
          throwsUnauthenticated,
        );
      });

      test('when not the owner, then notFound / forbidden', () async {
        final private = await create();
        await expectLater(
          endpoints.projectCollaboration.listJoinRequests(
            alice.session,
            private.id,
          ),
          throwsAppException(ErrorCode.notFound),
        );
        final public = await openPublic();
        await expectLater(
          endpoints.projectCollaboration.listJoinRequests(
            alice.session,
            public.id,
          ),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test(
        'when the owner lists, then requester emails are included',
        () async {
          final project = await openPublic();
          await requestJoin(project, alice, ProjectRole.write);

          final requests = await endpoints.projectCollaboration
              .listJoinRequests(
                owner.session,
                project.id,
              );

          expect(requests.single.email, alice.email);
          expect(requests.single.role, ProjectRole.write);
        },
      );
    });

    group('respondToJoinRequest', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);
        await expectLater(
          endpoints.projectCollaboration.respondToJoinRequest(
            unauthenticated,
            request.id,
            true,
          ),
          throwsUnauthenticated,
        );
      });

      test('when not the owner (even the requester), then notFound', () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);
        await expectLater(
          endpoints.projectCollaboration.respondToJoinRequest(
            alice.session,
            request.id,
            true,
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test(
        'when the owner accepts, then the requester becomes a member',
        () async {
          final project = await openPublic();
          final request = await requestJoin(project, alice, ProjectRole.write);

          await endpoints.projectCollaboration.respondToJoinRequest(
            owner.session,
            request.id,
            true,
          );

          final seen = await endpoints.project.getById(
            alice.session,
            project.id,
          );
          expect(seen.access, ProjectAccess.write);
          expect(seen.hasPendingJoinRequest, isFalse);
        },
      );

      test('when the owner declines, then no membership is created', () async {
        final project = await openPublic();
        final request = await requestJoin(project, alice);

        await endpoints.projectCollaboration.respondToJoinRequest(
          owner.session,
          request.id,
          false,
        );

        final seen = await endpoints.project.getById(alice.session, project.id);
        expect(seen.access, ProjectAccess.none);
        expect(seen.hasPendingJoinRequest, isFalse);
      });
    });

    group('project settings changes', () {
      test(
        'when contributions are turned off, then pending invitations and requests are deleted',
        () async {
          final project = await openPublic();
          await invite(project, bob.email);
          await requestJoin(project, alice);

          await endpoints.project.update(
            owner.session,
            project.id,
            updateRequest(project, allowContributions: false),
          );

          expect(
            await endpoints.projectCollaboration.myInvitations(bob.session),
            isEmpty,
          );
          expect(
            await endpoints.projectCollaboration.myJoinRequests(alice.session),
            isEmpty,
          );
        },
      );

      test(
        'when the project becomes private, then pending join requests are deleted but invitations stay',
        () async {
          final project = await openPublic();
          await invite(project, bob.email);
          await requestJoin(project, alice);

          await endpoints.project.update(
            owner.session,
            project.id,
            updateRequest(project, visibility: ProjectVisibility.private),
          );

          expect(
            await endpoints.projectCollaboration.myJoinRequests(alice.session),
            isEmpty,
          );
          expect(
            await endpoints.projectCollaboration.myInvitations(bob.session),
            hasLength(1),
          );
        },
      );

      test(
        'when the project is deleted, then invitations and requests cascade',
        () async {
          final project = await openPublic();
          await invite(project, bob.email);
          await requestJoin(project, alice);

          await endpoints.project.delete(owner.session, project.id);

          expect(
            await endpoints.projectCollaboration.myInvitations(bob.session),
            isEmpty,
          );
          expect(
            await endpoints.projectCollaboration.myJoinRequests(alice.session),
            isEmpty,
          );
        },
      );
    });
  });
}
