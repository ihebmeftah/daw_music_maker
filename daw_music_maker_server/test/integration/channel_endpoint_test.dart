import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Channel endpoint', (sessionBuilder, endpoints) {
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

    Future<List<ChannelResponse>> list([TestUser? user]) =>
        endpoints.channel.list((user ?? owner).session, project.id);

    Future<ChannelResponse> firstChannel() async => (await list()).first;

    CreateChannelRequest create({
      SampleKind sample = SampleKind.snare,
      String? name,
    }) => CreateChannelRequest(
      projectId: project.id,
      sample: sample,
      name: name,
    );

    UpdateChannelRequest update({
      String name = 'Big Kick',
      double volume = 0.5,
      bool muted = true,
    }) => UpdateChannelRequest(name: name, volume: volume, muted: muted);

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
    });

    group('list', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.channel.list(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user lists a private project, then notFound',
        () async {
          await expectLater(
            list(other),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test(
        'when a project is new, then it has the default drum rack',
        () async {
          final channels = await list();

          expect(channels.map((c) => c.name), [
            'Kick',
            'Snare',
            'Hat',
            'Open Hat',
          ]);
          expect(channels.map((c) => c.sample), [
            SampleKind.kick,
            SampleKind.snare,
            SampleKind.closedHat,
            SampleKind.openHat,
          ]);
          expect(channels.map((c) => c.position), [0, 1, 2, 3]);
          expect(channels.every((c) => c.volume == 0.8 && !c.muted), isTrue);
          expect(channels.every((c) => c.projectId == project.id), isTrue);
        },
      );

      test('when a read member lists, then it is allowed', () async {
        await addMember(other, ProjectRole.read);

        expect(await list(other), hasLength(4));
      });

      test(
        'when a visitor lists a public project, then it is allowed',
        () async {
          final public = await endpoints.project.create(
            owner.session,
            createRequest(visibility: ProjectVisibility.public),
          );

          final channels = await endpoints.channel.list(
            other.session,
            public.id,
          );

          expect(channels, hasLength(4));
        },
      );
    });

    group('create', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.channel.create(unauthenticated, create()),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          await expectLater(
            endpoints.channel.create(other.session, create()),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member creates, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          endpoints.channel.create(other.session, create()),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the name is invalid, then validation fails', () async {
        await expectLater(
          endpoints.channel.create(owner.session, create(name: '   ')),
          throwsAppException(ErrorCode.validation),
        );
        await expectLater(
          endpoints.channel.create(owner.session, create(name: 'a' * 41)),
          throwsAppException(ErrorCode.validation),
        );
      });

      test(
        'when no name is given, then it defaults from the sample and appends',
        () async {
          final channel = await endpoints.channel.create(
            owner.session,
            create(sample: SampleKind.openHat),
          );

          expect(channel.name, 'Open Hat');
          expect(channel.sample, SampleKind.openHat);
          expect(channel.position, 4);
          expect(channel.volume, 0.8);
          expect(channel.muted, isFalse);
          expect((await list()).last.id, channel.id);
        },
      );

      test('when a name is given, then it is trimmed', () async {
        final channel = await endpoints.channel.create(
          owner.session,
          create(name: '  Clap  '),
        );

        expect(channel.name, 'Clap');
      });

      test('when a write member creates, then it is allowed', () async {
        await addMember(other, ProjectRole.write);

        final channel = await endpoints.channel.create(other.session, create());

        expect(channel.projectId, project.id);
      });

      test('when the project has 32 channels, then limitReached', () async {
        final session = sessionBuilder.build();
        for (var i = 4; i < 32; i++) {
          await Channel.db.insertRow(
            session,
            Channel(
              projectId: project.id,
              name: 'Ch $i',
              sample: SampleKind.kick,
              position: i,
            ),
          );
        }

        await expectLater(
          endpoints.channel.create(owner.session, create()),
          throwsAppException(ErrorCode.limitReached),
        );
      });
    });

    group('update', () {
      test('when unauthenticated, then it is rejected', () async {
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.update(unauthenticated, channel.id, update()),
          throwsUnauthenticated,
        );
      });

      test('when another user updates, then notFound', () async {
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.update(other.session, channel.id, update()),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when the channel does not exist, then notFound', () async {
        await expectLater(
          endpoints.channel.update(
            owner.session,
            UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4e99'),
            update(),
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when a read member updates, then forbidden', () async {
        await addMember(other, ProjectRole.read);
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.update(other.session, channel.id, update()),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the input is invalid, then validation fails', () async {
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.update(owner.session, channel.id, update(name: '')),
          throwsAppException(ErrorCode.validation),
        );
        await expectLater(
          endpoints.channel.update(
            owner.session,
            channel.id,
            update(volume: 1.5),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test(
        'when the owner updates, then name, volume and mute are saved',
        () async {
          final channel = await firstChannel();

          final updated = await endpoints.channel.update(
            owner.session,
            channel.id,
            update(name: '  Big Kick ', volume: 0.25, muted: true),
          );

          expect(updated.name, 'Big Kick');
          expect(updated.volume, 0.25);
          expect(updated.muted, isTrue);
          expect(updated.sample, SampleKind.kick);
          expect((await list()).first.name, 'Big Kick');
        },
      );

      test('when a write member updates, then it is allowed', () async {
        await addMember(other, ProjectRole.write);
        final channel = await firstChannel();

        final updated = await endpoints.channel.update(
          other.session,
          channel.id,
          update(muted: false),
        );

        expect(updated.muted, isFalse);
      });
    });

    group('delete', () {
      test('when unauthenticated, then it is rejected', () async {
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.delete(unauthenticated, channel.id),
          throwsUnauthenticated,
        );
      });

      test('when another user deletes, then notFound', () async {
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.delete(other.session, channel.id),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when a read member deletes, then forbidden', () async {
        await addMember(other, ProjectRole.read);
        final channel = await firstChannel();

        await expectLater(
          endpoints.channel.delete(other.session, channel.id),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test(
        'when the owner deletes, then the channel and its notes are gone',
        () async {
          final channels = await list();
          final kick = channels[0];
          final snare = channels[1];
          final pattern = (await endpoints.pattern.list(
            owner.session,
            project.id,
          )).first;
          await endpoints.pattern.saveNotes(
            owner.session,
            pattern.id,
            SavePatternNotesRequest(
              notes: [
                NoteInput(
                  channelId: kick.id,
                  tick: 0,
                  lengthTicks: 240,
                  pitch: 60,
                  velocity: 100,
                ),
                NoteInput(
                  channelId: snare.id,
                  tick: 960,
                  lengthTicks: 240,
                  pitch: 60,
                  velocity: 100,
                ),
              ],
            ),
          );

          await endpoints.channel.delete(owner.session, kick.id);

          expect((await list()).map((c) => c.id), isNot(contains(kick.id)));
          final notes = await endpoints.pattern.listNotes(
            owner.session,
            pattern.id,
          );
          expect(notes, hasLength(1));
          expect(notes.single.channelId, snare.id);
        },
      );
    });

    test(
      'when the project is deleted, then its channels are deleted',
      () async {
        await endpoints.project.delete(owner.session, project.id);

        final remaining = await Channel.db.count(
          sessionBuilder.build(),
          where: (t) => t.projectId.equals(project.id),
        );
        expect(remaining, 0);
      },
    );
  });
}
