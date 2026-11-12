import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Playlist endpoint', (sessionBuilder, endpoints) {
    late TestUser owner;
    late TestUser other;
    late ProjectResponse project;
    late PatternResponse pattern;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    Future<void> addMember(TestUser user, ProjectRole role) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    ClipInput clip({UuidValue? patternId, int track = 0, int startBar = 0}) =>
        ClipInput(
          patternId: patternId ?? pattern.id,
          track: track,
          startBar: startBar,
        );

    Future<List<ClipResponse>> save(TestUser user, List<ClipInput> clips) =>
        endpoints.playlist.save(
          user.session,
          project.id,
          SavePlaylistRequest(clips: clips),
        );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
      pattern = (await endpoints.pattern.list(owner.session, project.id)).first;
    });

    group('list', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.playlist.list(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user lists a private project, then notFound',
        () async {
          await expectLater(
            endpoints.playlist.list(other.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a project is new, then its playlist is empty', () async {
        expect(
          await endpoints.playlist.list(owner.session, project.id),
          isEmpty,
        );
      });

      test('when a read member lists, then sees the clips', () async {
        await save(owner, [clip()]);
        await addMember(other, ProjectRole.read);

        final clips = await endpoints.playlist.list(other.session, project.id);

        expect(clips, hasLength(1));
      });

      test(
        'when a visitor lists a public project, then sees the clips',
        () async {
          project = await endpoints.project.create(
            owner.session,
            createRequest(visibility: ProjectVisibility.public),
          );
          pattern = (await endpoints.pattern.list(
            owner.session,
            project.id,
          )).first;
          await save(owner, [clip()]);

          final clips = await endpoints.playlist.list(
            other.session,
            project.id,
          );

          expect(clips.single.patternId, pattern.id);
        },
      );
    });

    group('save', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.playlist.save(
            unauthenticated,
            project.id,
            SavePlaylistRequest(clips: []),
          ),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user saves a private project, then notFound',
        () async {
          await expectLater(
            save(other, [clip()]),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member saves, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          save(other, [clip()]),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when a write member saves, then it is stored', () async {
        await addMember(other, ProjectRole.write);

        final saved = await save(other, [clip(track: 2, startBar: 8)]);

        expect(saved.single.track, 2);
        expect(saved.single.startBar, 8);
      });

      test('when the input is invalid, then validation fails', () async {
        for (final bad in [
          [clip(track: 16)],
          [clip(startBar: -1)],
          [clip(startBar: 253)],
          [clip(), clip(startBar: 2)],
        ]) {
          await expectLater(
            save(owner, bad),
            throwsAppException(ErrorCode.validation),
          );
        }
      });

      test(
        'when a clip uses a pattern of another project, then validation fails',
        () async {
          final foreign = await endpoints.project.create(
            other.session,
            createRequest(),
          );
          final foreignPattern = (await endpoints.pattern.list(
            other.session,
            foreign.id,
          )).first;

          await expectLater(
            save(owner, [clip(patternId: foreignPattern.id)]),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when saving, then replaces the whole list ordered by track and bar',
        () async {
          await save(owner, [clip(track: 5)]);

          final saved = await save(owner, [
            clip(track: 1, startBar: 8),
            clip(track: 1, startBar: 0),
            clip(track: 0, startBar: 4),
          ]);
          final listed = await endpoints.playlist.list(
            owner.session,
            project.id,
          );

          expect(saved, hasLength(3));
          expect(
            [for (final c in listed) (c.track, c.startBar)],
            [
              (0, 4),
              (1, 0),
              (1, 8),
            ],
          );
        },
      );

      test('when saving an empty list, then the playlist is cleared', () async {
        await save(owner, [clip()]);

        await save(owner, []);

        expect(
          await endpoints.playlist.list(owner.session, project.id),
          isEmpty,
        );
      });

      test(
        'when a pattern is 8 bars, then a clip 4 bars later overlaps',
        () async {
          final long = await endpoints.pattern.create(
            owner.session,
            CreatePatternRequest(projectId: project.id, lengthBars: 8),
          );

          await expectLater(
            save(owner, [clip(patternId: long.id), clip(startBar: 4)]),
            throwsAppException(ErrorCode.validation),
          );
          await save(owner, [clip(patternId: long.id), clip(startBar: 8)]);
        },
      );
    });

    group('cascades', () {
      test('when a pattern is deleted, then its clips are removed', () async {
        final second = await endpoints.pattern.create(
          owner.session,
          CreatePatternRequest(projectId: project.id),
        );
        await save(owner, [
          clip(),
          clip(patternId: second.id, track: 1),
        ]);

        await endpoints.pattern.delete(owner.session, second.id);

        final clips = await endpoints.playlist.list(owner.session, project.id);
        expect(clips.single.patternId, pattern.id);
      });

      test('when the project is deleted, then its clips are removed', () async {
        await save(owner, [clip(), clip(track: 1)]);

        await endpoints.project.delete(owner.session, project.id);

        final remaining = await PlaylistClip.db.count(
          sessionBuilder.build(),
          where: (t) => t.projectId.equals(project.id),
        );
        expect(remaining, 0);
      });
    });
  });
}
