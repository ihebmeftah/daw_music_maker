import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Project endpoint', (sessionBuilder, endpoints) {
    late TestUser owner;
    late TestUser other;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
    });

    Future<ProjectResponse> create(
      TestUser user, {
      String name = 'Night Drive',
      ProjectVisibility visibility = ProjectVisibility.private,
      bool allowContributions = false,
    }) => endpoints.project.create(
      user.session,
      createRequest(
        name: name,
        visibility: visibility,
        allowContributions: allowContributions,
      ),
    );

    Future<void> addMember(
      ProjectResponse project,
      TestUser user,
      ProjectRole role,
    ) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    group('create', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.project.create(unauthenticated, createRequest()),
          throwsUnauthenticated,
        );
      });

      test(
        'when the name is blank, then a validation error is thrown',
        () async {
          await expectLater(
            endpoints.project.create(owner.session, createRequest(name: '  ')),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when there are too many genres, then a validation error is thrown',
        () async {
          await expectLater(
            endpoints.project.create(
              owner.session,
              createRequest(genres: [for (var i = 0; i < 9; i++) 'g$i']),
            ),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when valid, then returns the normalized project owned by the caller',
        () async {
          final project = await endpoints.project.create(
            owner.session,
            createRequest(
              name: '  Night Drive ',
              genres: [' Techno', 'techno', 'House'],
              visibility: ProjectVisibility.public,
              allowContributions: true,
            ),
          );

          expect(project.name, 'Night Drive');
          expect(project.genres, ['Techno', 'House']);
          expect(project.ownerId, owner.id);
          expect(project.access, ProjectAccess.owner);
          expect(project.visibility, ProjectVisibility.public);
          expect(project.allowContributions, isTrue);
          expect(project.memberCount, 0);
        },
      );
    });

    group('getById', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create(owner);
        await expectLater(
          endpoints.project.getById(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        "when reading another user's private project, then notFound",
        () async {
          final project = await create(owner);
          await expectLater(
            endpoints.project.getById(other.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when reading a public project, then access is none', () async {
        final project = await create(
          owner,
          visibility: ProjectVisibility.public,
        );

        final seen = await endpoints.project.getById(other.session, project.id);

        expect(seen.access, ProjectAccess.none);
      });

      test(
        'when a member reads a private project, then access matches the role',
        () async {
          final project = await create(owner);
          await addMember(project, other, ProjectRole.read);

          final seen = await endpoints.project.getById(
            other.session,
            project.id,
          );

          expect(seen.access, ProjectAccess.read);
          expect(seen.memberCount, 1);
        },
      );
    });

    group('listMine', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.project.listMine(unauthenticated),
          throwsUnauthenticated,
        );
      });

      test(
        'when listing, then only own projects are returned with paging',
        () async {
          await create(owner, name: 'A');
          await create(owner, name: 'B');
          await create(owner, name: 'C');
          await create(other, name: 'Not mine');

          final first = await endpoints.project.listMine(
            owner.session,
            limit: 2,
          );
          final second = await endpoints.project.listMine(
            owner.session,
            limit: 2,
            offset: 2,
          );

          expect(first.items, hasLength(2));
          expect(first.hasMore, isTrue);
          expect(second.items, hasLength(1));
          expect(second.hasMore, isFalse);
          expect(
            [
              ...first.items,
              ...second.items,
            ].every((p) => p.ownerId == owner.id),
            isTrue,
          );
        },
      );
    });

    group('listShared', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.project.listShared(unauthenticated),
          throwsUnauthenticated,
        );
      });

      test(
        'when a member, then the shared project is listed with its role',
        () async {
          final shared = await create(owner, name: 'Shared');
          await create(owner, name: 'Not shared');
          await addMember(shared, other, ProjectRole.write);

          final page = await endpoints.project.listShared(other.session);

          expect(page.items.map((p) => p.id), [shared.id]);
          expect(page.items.single.access, ProjectAccess.write);
        },
      );
    });

    group('discover', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.project.discover(unauthenticated),
          throwsUnauthenticated,
        );
      });

      test(
        'when discovering, then own and private projects are excluded',
        () async {
          final public = await create(
            other,
            name: 'Public jam',
            visibility: ProjectVisibility.public,
          );
          final private = await create(other, name: 'Secret');
          final mine = await create(
            owner,
            name: 'My public',
            visibility: ProjectVisibility.public,
          );

          final page = await endpoints.project.discover(
            owner.session,
            limit: 50,
          );
          final ids = page.items.map((p) => p.id).toSet();

          expect(ids, contains(public.id));
          expect(ids, isNot(contains(private.id)));
          expect(ids, isNot(contains(mine.id)));
        },
      );

      test(
        'when querying, then filters by name and matches % literally',
        () async {
          final tag = DateTime.now().microsecondsSinceEpoch;
          final percent = await create(
            other,
            name: '100% Dub $tag',
            visibility: ProjectVisibility.public,
          );
          final plain = await create(
            other,
            name: '1000 Dub $tag',
            visibility: ProjectVisibility.public,
          );

          final byName = await endpoints.project.discover(
            owner.session,
            query: 'dub $tag',
          );
          final byPercent = await endpoints.project.discover(
            owner.session,
            query: '100%',
          );

          expect(byName.items.map((p) => p.id).toSet(), {percent.id, plain.id});
          expect(byPercent.items.map((p) => p.id), contains(percent.id));
          expect(byPercent.items.map((p) => p.id), isNot(contains(plain.id)));
        },
      );
    });

    group('update', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create(owner);
        await expectLater(
          endpoints.project.update(
            unauthenticated,
            project.id,
            updateRequest(project),
          ),
          throwsUnauthenticated,
        );
      });

      test(
        "when updating another user's private project, then notFound",
        () async {
          final project = await create(owner);
          await expectLater(
            endpoints.project.update(
              other.session,
              project.id,
              updateRequest(project, name: 'Hijack'),
            ),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test(
        'when the new name is invalid, then a validation error is thrown',
        () async {
          final project = await create(owner);
          await expectLater(
            endpoints.project.update(
              owner.session,
              project.id,
              updateRequest(project, name: ''),
            ),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test('when the owner updates, then all fields change', () async {
        final project = await create(owner);

        final updated = await endpoints.project.update(
          owner.session,
          project.id,
          updateRequest(
            project,
            name: 'Renamed',
            genres: ['Ambient'],
            visibility: ProjectVisibility.public,
            allowContributions: true,
          ),
        );

        expect(updated.name, 'Renamed');
        expect(updated.genres, ['Ambient']);
        expect(updated.visibility, ProjectVisibility.public);
        expect(updated.allowContributions, isTrue);
      });

      test('when a write member edits details, then it succeeds', () async {
        final project = await create(owner);
        await addMember(project, other, ProjectRole.write);

        final updated = await endpoints.project.update(
          other.session,
          project.id,
          updateRequest(project, name: 'Writer edit', genres: ['Dub']),
        );

        expect(updated.name, 'Writer edit');
        expect(updated.access, ProjectAccess.write);
      });

      test(
        'when a write member changes visibility or contributions, then forbidden',
        () async {
          final project = await create(owner);
          await addMember(project, other, ProjectRole.write);

          await expectLater(
            endpoints.project.update(
              other.session,
              project.id,
              updateRequest(project, visibility: ProjectVisibility.public),
            ),
            throwsAppException(ErrorCode.forbidden),
          );
          await expectLater(
            endpoints.project.update(
              other.session,
              project.id,
              updateRequest(project, allowContributions: true),
            ),
            throwsAppException(ErrorCode.forbidden),
          );
        },
      );

      test('when a read member updates, then forbidden', () async {
        final project = await create(owner);
        await addMember(project, other, ProjectRole.read);

        await expectLater(
          endpoints.project.update(
            other.session,
            project.id,
            updateRequest(project, name: 'Nope'),
          ),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when a public viewer updates, then forbidden', () async {
        final project = await create(
          owner,
          visibility: ProjectVisibility.public,
        );

        await expectLater(
          endpoints.project.update(
            other.session,
            project.id,
            updateRequest(project, name: 'Nope'),
          ),
          throwsAppException(ErrorCode.forbidden),
        );
      });
    });

    group('delete', () {
      test('when unauthenticated, then it is rejected', () async {
        final project = await create(owner);
        await expectLater(
          endpoints.project.delete(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        "when deleting another user's private project, then notFound",
        () async {
          final project = await create(owner);
          await expectLater(
            endpoints.project.delete(other.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a member deletes, then forbidden', () async {
        final project = await create(owner);
        await addMember(project, other, ProjectRole.write);
        await expectLater(
          endpoints.project.delete(other.session, project.id),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test(
        'when the owner deletes, then the project and its members are gone',
        () async {
          final project = await create(owner);
          await addMember(project, other, ProjectRole.read);

          await endpoints.project.delete(owner.session, project.id);

          await expectLater(
            endpoints.project.getById(owner.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
          final members = await ProjectMember.db.count(
            sessionBuilder.build(),
            where: (t) => t.projectId.equals(project.id),
          );
          expect(members, 0);
        },
      );
    });
  });
}
