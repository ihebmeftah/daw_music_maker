import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Pattern endpoint', (sessionBuilder, endpoints) {
    late TestUser owner;
    late TestUser other;
    late ProjectResponse project;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    Future<void> addMember(TestUser user, ProjectRole role) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    Future<List<PatternResponse>> list(TestUser user) =>
        endpoints.pattern.list(user.session, project.id);

    Future<PatternResponse> firstPattern() async => (await list(owner)).first;

    CreatePatternRequest create({
      String? name,
      int? colorIndex,
      int? lengthBars,
    }) => CreatePatternRequest(
      projectId: project.id,
      name: name,
      colorIndex: colorIndex,
      lengthBars: lengthBars,
    );

    UpdatePatternRequest update({
      String name = 'Drums',
      int colorIndex = 2,
      int lengthBars = 8,
    }) => UpdatePatternRequest(
      name: name,
      colorIndex: colorIndex,
      lengthBars: lengthBars,
    );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
    });

    group('list', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.pattern.list(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when a project is created, then it has exactly one default pattern',
        () async {
          final patterns = await list(owner);

          expect(patterns, hasLength(1));
          expect(patterns.single.name, 'Pattern 1');
          expect(patterns.single.lengthBars, 4);
          expect(patterns.single.colorIndex, 0);
          expect(patterns.single.position, 0);
          expect(patterns.single.projectId, project.id);
        },
      );

      test(
        'when another user lists a private project, then notFound',
        () async {
          await expectLater(
            list(other),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member lists, then it is allowed', () async {
        await addMember(other, ProjectRole.read);

        expect(await list(other), hasLength(1));
      });

      test(
        'when a visitor lists a public project, then it is allowed',
        () async {
          project = await endpoints.project.create(
            owner.session,
            createRequest(visibility: ProjectVisibility.public),
          );

          expect(await list(other), hasLength(1));
        },
      );

      test(
        'when several patterns exist, then they come in position order',
        () async {
          await endpoints.pattern.create(owner.session, create(name: 'B'));
          await endpoints.pattern.create(owner.session, create(name: 'C'));

          final patterns = await list(owner);

          expect(patterns.map((p) => p.name), ['Pattern 1', 'B', 'C']);
          expect(patterns.map((p) => p.position), [0, 1, 2]);
        },
      );
    });

    group('create', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.pattern.create(unauthenticated, create()),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          await expectLater(
            endpoints.pattern.create(other.session, create()),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member creates, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          endpoints.pattern.create(other.session, create()),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the input is invalid, then validation fails', () async {
        await expectLater(
          endpoints.pattern.create(
            owner.session,
            create(name: ' ', colorIndex: 8, lengthBars: 17),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test('when created without fields, then gets defaults', () async {
        final created = await endpoints.pattern.create(owner.session, create());

        expect(created.name, 'Pattern 2');
        expect(created.colorIndex, 1);
        expect(created.lengthBars, 4);
        expect(created.position, 1);
      });

      test('when created with fields, then keeps them (trimmed)', () async {
        final created = await endpoints.pattern.create(
          owner.session,
          create(name: '  Hats ', colorIndex: 5, lengthBars: 2),
        );

        expect(created.name, 'Hats');
        expect(created.colorIndex, 5);
        expect(created.lengthBars, 2);
      });

      test('when a write member creates, then it is saved', () async {
        await addMember(other, ProjectRole.write);

        final created = await endpoints.pattern.create(other.session, create());

        expect(created.name, 'Pattern 2');
        expect(await list(owner), hasLength(2));
      });

      test('when the project has 99 patterns, then limitReached', () async {
        final session = sessionBuilder.build();
        await Pattern.db.insert(session, [
          for (var i = 1; i < 99; i++)
            Pattern(projectId: project.id, name: 'P$i', position: i),
        ]);

        await expectLater(
          endpoints.pattern.create(owner.session, create()),
          throwsAppException(ErrorCode.limitReached),
        );
      });
    });

    group('update', () {
      test('when unauthenticated, then it is rejected', () async {
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.update(unauthenticated, pattern.id, update()),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          final pattern = await firstPattern();

          await expectLater(
            endpoints.pattern.update(other.session, pattern.id, update()),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when the pattern does not exist, then notFound', () async {
        await expectLater(
          endpoints.pattern.update(
            owner.session,
            UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e5f'),
            update(),
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when a read member updates, then forbidden', () async {
        await addMember(other, ProjectRole.read);
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.update(other.session, pattern.id, update()),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the input is invalid, then validation fails', () async {
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.update(
            owner.session,
            pattern.id,
            update(lengthBars: 0),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test('when the owner updates, then the changes are saved', () async {
        final pattern = await firstPattern();

        final updated = await endpoints.pattern.update(
          owner.session,
          pattern.id,
          update(name: ' Drums ', colorIndex: 6, lengthBars: 16),
        );

        expect(updated.name, 'Drums');
        expect(updated.colorIndex, 6);
        expect(updated.lengthBars, 16);
        expect(updated.position, pattern.position);
        expect((await firstPattern()).name, 'Drums');
      });

      test('when a write member updates, then the changes are saved', () async {
        await addMember(other, ProjectRole.write);
        final pattern = await firstPattern();

        final updated = await endpoints.pattern.update(
          other.session,
          pattern.id,
          update(),
        );

        expect(updated.name, 'Drums');
      });
    });

    group('clone', () {
      test('when unauthenticated, then it is rejected', () async {
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.clone(unauthenticated, pattern.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          final pattern = await firstPattern();

          await expectLater(
            endpoints.pattern.clone(other.session, pattern.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member clones, then forbidden', () async {
        await addMember(other, ProjectRole.read);
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.clone(other.session, pattern.id),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the owner clones, then a copy is appended', () async {
        final source = await endpoints.pattern.update(
          owner.session,
          (await firstPattern()).id,
          update(name: 'Drums', colorIndex: 4, lengthBars: 2),
        );
        await endpoints.pattern.create(owner.session, create(name: 'Bass'));

        final copy = await endpoints.pattern.clone(owner.session, source.id);

        expect(copy.name, 'Drums (copy)');
        expect(copy.colorIndex, 4);
        expect(copy.lengthBars, 2);
        expect(copy.position, 2);
        expect(copy.id, isNot(source.id));
        expect((await list(owner)).map((p) => p.name), [
          'Drums',
          'Bass',
          'Drums (copy)',
        ]);
      });

      test('when the project has 99 patterns, then limitReached', () async {
        final session = sessionBuilder.build();
        await Pattern.db.insert(session, [
          for (var i = 1; i < 99; i++)
            Pattern(projectId: project.id, name: 'P$i', position: i),
        ]);
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.clone(owner.session, pattern.id),
          throwsAppException(ErrorCode.limitReached),
        );
      });
    });

    group('delete', () {
      test('when unauthenticated, then it is rejected', () async {
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.delete(unauthenticated, pattern.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          await endpoints.pattern.create(owner.session, create());
          final pattern = await firstPattern();

          await expectLater(
            endpoints.pattern.delete(other.session, pattern.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member deletes, then forbidden', () async {
        await addMember(other, ProjectRole.read);
        await endpoints.pattern.create(owner.session, create());
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.delete(other.session, pattern.id),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when deleting the last pattern, then conflict', () async {
        final pattern = await firstPattern();

        await expectLater(
          endpoints.pattern.delete(owner.session, pattern.id),
          throwsAppException(ErrorCode.conflict),
        );
        expect(await list(owner), hasLength(1));
      });

      test('when deleting a non-last pattern, then it is removed', () async {
        final second = await endpoints.pattern.create(owner.session, create());

        await endpoints.pattern.delete(owner.session, second.id);

        final patterns = await list(owner);
        expect(patterns, hasLength(1));
        expect(patterns.single.name, 'Pattern 1');
      });

      test(
        'when the project is deleted, then its patterns are deleted',
        () async {
          await endpoints.pattern.create(owner.session, create());

          await endpoints.project.delete(owner.session, project.id);

          final remaining = await Pattern.db.count(
            sessionBuilder.build(),
            where: (t) => t.projectId.equals(project.id),
          );
          expect(remaining, 0);
        },
      );
    });
  });
}
