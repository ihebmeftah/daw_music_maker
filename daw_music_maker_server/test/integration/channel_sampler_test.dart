import 'package:daw_music_maker_server/src/core/validation/validation_rules.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given channel sampler settings', (sessionBuilder, endpoints) {
    late TestUser owner;
    late TestUser other;
    late ProjectResponse project;
    late ChannelResponse kick;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    Future<void> addMember(TestUser user, ProjectRole role) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    UpdateChannelRequest settings({
      double pan = 0,
      int pitch = 0,
      double startFrac = 0,
      double endFrac = 1,
    }) => UpdateChannelRequest(
      name: 'Kick',
      volume: 0.8,
      muted: false,
      pan: pan,
      pitch: pitch,
      startFrac: startFrac,
      endFrac: endFrac,
    );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
      kick = (await endpoints.channel.list(owner.session, project.id)).first;
    });

    group('update', () {
      test(
        'when pan, pitch and region are valid, then they are saved',
        () async {
          final saved = await endpoints.channel.update(
            owner.session,
            kick.id,
            settings(pan: -0.5, pitch: 7, startFrac: 0.25, endFrac: 0.75),
          );

          expect(saved.pan, -0.5);
          expect(saved.pitch, 7);
          expect(saved.startFrac, 0.25);
          expect(saved.endFrac, 0.75);
          final listed = (await endpoints.channel.list(
            owner.session,
            project.id,
          )).first;
          expect(listed.pitch, 7);
        },
      );

      test('when pan, pitch or region are invalid, then validation', () async {
        for (final request in [
          settings(pan: 1.5),
          settings(pitch: 25),
          settings(pitch: -25),
          settings(startFrac: 0.6, endFrac: 0.4),
          settings(endFrac: 1.2),
        ]) {
          await expectLater(
            endpoints.channel.update(owner.session, kick.id, request),
            throwsAppException(ErrorCode.validation),
          );
        }
      });
    });

    group('chop', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.channel.chop(
            unauthenticated,
            kick.id,
            ChopChannelRequest(slices: 2),
          ),
          throwsUnauthenticated,
        );
      });

      test('when another user chops, then notFound', () async {
        await expectLater(
          endpoints.channel.chop(
            other.session,
            kick.id,
            ChopChannelRequest(slices: 2),
          ),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when a read member chops, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          endpoints.channel.chop(
            other.session,
            kick.id,
            ChopChannelRequest(slices: 2),
          ),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the slice count is not 2/4/8/16, then validation', () async {
        await expectLater(
          endpoints.channel.chop(
            owner.session,
            kick.id,
            ChopChannelRequest(slices: 3),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      for (final slices in [2, 4, 8, 16]) {
        test(
          'when chopping into $slices, then contiguous named slices are added',
          () async {
            await endpoints.channel.update(
              owner.session,
              kick.id,
              settings(pan: 0.3, pitch: -2, startFrac: 0.2, endFrac: 0.6),
            );

            final created = await endpoints.channel.chop(
              owner.session,
              kick.id,
              ChopChannelRequest(slices: slices),
            );

            expect(created, hasLength(slices));
            expect(created.map((c) => c.name), [
              for (var i = 1; i <= slices; i++) 'Kick $i',
            ]);
            expect(created.first.startFrac, closeTo(0.2, 1e-9));
            expect(created.last.endFrac, closeTo(0.6, 1e-9));
            for (var i = 1; i < created.length; i++) {
              expect(
                created[i].startFrac,
                closeTo(created[i - 1].endFrac, 1e-9),
              );
            }
            expect(created.every((c) => c.sample == SampleKind.kick), isTrue);
            expect(created.every((c) => c.pitch == -2 && c.pan == 0.3), isTrue);
            final all = await endpoints.channel.list(owner.session, project.id);
            expect(all, hasLength(4 + slices));
            expect(all.last.name, 'Kick $slices');
          },
        );
      }

      test('when the rack would pass 32 channels, then limitReached', () async {
        final session = sessionBuilder.build();
        for (var i = 4; i < ValidationRules.channelsMax - 1; i++) {
          await Channel.db.insertRow(
            session,
            Channel(
              projectId: project.id,
              name: 'C$i',
              sample: SampleKind.kick,
              position: i,
            ),
          );
        }

        await expectLater(
          endpoints.channel.chop(
            owner.session,
            kick.id,
            ChopChannelRequest(slices: 2),
          ),
          throwsAppException(ErrorCode.limitReached),
        );
      });

      test('when a write member chops, then it works', () async {
        await addMember(other, ProjectRole.write);

        final created = await endpoints.channel.chop(
          other.session,
          kick.id,
          ChopChannelRequest(slices: 2),
        );

        expect(created, hasLength(2));
      });
    });
  });
}
