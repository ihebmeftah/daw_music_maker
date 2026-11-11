import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Project.updateTempo', (sessionBuilder, endpoints) {
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

    UpdateProjectTempoRequest tempo(double bpm) =>
        UpdateProjectTempoRequest(bpm: bpm);

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
    });

    test('when a project is created, then its tempo defaults to 120', () {
      expect(project.bpm, 120);
    });

    test('when unauthenticated, then the call is rejected', () async {
      await expectLater(
        endpoints.project.updateTempo(unauthenticated, project.id, tempo(90)),
        throwsUnauthenticated,
      );
    });

    test(
      'when another user targets a private project, then notFound',
      () async {
        await expectLater(
          endpoints.project.updateTempo(other.session, project.id, tempo(90)),
          throwsAppException(ErrorCode.notFound),
        );
      },
    );

    test(
      'when the owner sets a valid tempo, then it is saved rounded',
      () async {
        final updated = await endpoints.project.updateTempo(
          owner.session,
          project.id,
          tempo(128.456),
        );

        expect(updated.bpm, 128.46);
        final reloaded = await endpoints.project.getById(
          owner.session,
          project.id,
        );
        expect(reloaded.bpm, 128.46);
      },
    );

    test('when a write member sets the tempo, then it is saved', () async {
      await addMember(other, ProjectRole.write);

      final updated = await endpoints.project.updateTempo(
        other.session,
        project.id,
        tempo(174),
      );

      expect(updated.bpm, 174);
      expect(updated.access, ProjectAccess.write);
    });

    test('when a read member sets the tempo, then forbidden', () async {
      await addMember(other, ProjectRole.read);

      await expectLater(
        endpoints.project.updateTempo(other.session, project.id, tempo(100)),
        throwsAppException(ErrorCode.forbidden),
      );
    });

    test('when the tempo is out of range, then validation fails', () async {
      // NaN and Infinity cannot be serialized by clients; the unit test covers them.
      for (final bpm in [19.99, 999.01, -5.0]) {
        await expectLater(
          endpoints.project.updateTempo(owner.session, project.id, tempo(bpm)),
          throwsAppException(ErrorCode.validation),
          reason: '$bpm',
        );
      }
    });

    test('when the tempo is at a boundary, then it is accepted', () async {
      for (final bpm in [20.0, 999.0]) {
        final updated = await endpoints.project.updateTempo(
          owner.session,
          project.id,
          tempo(bpm),
        );
        expect(updated.bpm, bpm);
      }
    });
  });
}
