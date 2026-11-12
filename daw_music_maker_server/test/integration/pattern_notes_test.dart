import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given pattern notes', (sessionBuilder, endpoints) {
    late TestUser owner;
    late TestUser other;
    late ProjectResponse project;
    late PatternResponse pattern;
    late List<ChannelResponse> channels;
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    Future<void> addMember(TestUser user, ProjectRole role) async {
      await ProjectMember.db.insertRow(
        sessionBuilder.build(),
        ProjectMember(projectId: project.id, userId: user.id, role: role),
      );
    }

    NoteInput note({
      int channel = 0,
      int tick = 0,
      int lengthTicks = 240,
      int pitch = 60,
      int velocity = 100,
    }) => NoteInput(
      channelId: channels[channel].id,
      tick: tick,
      lengthTicks: lengthTicks,
      pitch: pitch,
      velocity: velocity,
    );

    Future<List<NoteResponse>> save(
      List<NoteInput> notes, {
      TestUser? user,
      PatternResponse? target,
    }) => endpoints.pattern.saveNotes(
      (user ?? owner).session,
      (target ?? pattern).id,
      SavePatternNotesRequest(notes: notes),
    );

    Future<List<NoteResponse>> listNotes({
      TestUser? user,
      PatternResponse? target,
    }) => endpoints.pattern.listNotes(
      (user ?? owner).session,
      (target ?? pattern).id,
    );

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
      pattern = (await endpoints.pattern.list(owner.session, project.id)).first;
      channels = await endpoints.channel.list(owner.session, project.id);
    });

    group('listNotes', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.pattern.listNotes(unauthenticated, pattern.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user lists a private project, then notFound',
        () async {
          await expectLater(
            listNotes(user: other),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a new pattern is listed, then it has no notes', () async {
        expect(await listNotes(), isEmpty);
      });

      test('when a read member lists, then it is allowed', () async {
        await save([note()]);
        await addMember(other, ProjectRole.read);

        expect(await listNotes(user: other), hasLength(1));
      });

      test(
        'when a visitor lists a public project, then it is allowed',
        () async {
          final public = await endpoints.project.create(
            owner.session,
            createRequest(visibility: ProjectVisibility.public),
          );
          final publicPattern = (await endpoints.pattern.list(
            owner.session,
            public.id,
          )).first;

          final notes = await endpoints.pattern.listNotes(
            other.session,
            publicPattern.id,
          );

          expect(notes, isEmpty);
        },
      );
    });

    group('saveNotes', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.pattern.saveNotes(
            unauthenticated,
            pattern.id,
            SavePatternNotesRequest(notes: []),
          ),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user saves to a private project, then notFound',
        () async {
          await expectLater(
            save([note()], user: other),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member saves, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          save([note()], user: other),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when a write member saves, then it is allowed', () async {
        await addMember(other, ProjectRole.write);

        expect(await save([note()], user: other), hasLength(1));
      });

      test('when notes are invalid, then validation fails', () async {
        for (final bad in [
          note(tick: -1),
          note(tick: 4 * 3840),
          note(lengthTicks: 0),
          note(tick: 4 * 3840 - 10, lengthTicks: 20),
          note(pitch: 128),
          note(velocity: 0),
        ]) {
          await expectLater(
            save([bad]),
            throwsAppException(ErrorCode.validation),
          );
        }
        expect(await listNotes(), isEmpty);
      });

      test(
        'when a note uses another project channel, then validation fails',
        () async {
          final otherProject = await endpoints.project.create(
            owner.session,
            createRequest(name: 'Other'),
          );
          final foreign = (await endpoints.channel.list(
            owner.session,
            otherProject.id,
          )).first;

          await expectLater(
            save([
              NoteInput(
                channelId: foreign.id,
                tick: 0,
                lengthTicks: 240,
                pitch: 60,
                velocity: 100,
              ),
            ]),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when saved twice, then the second list replaces the first',
        () async {
          await save([note(), note(tick: 960)]);

          final saved = await save([note(channel: 1, tick: 480, pitch: 64)]);

          expect(saved, hasLength(1));
          final notes = await listNotes();
          expect(notes, hasLength(1));
          expect(notes.single.channelId, channels[1].id);
          expect(notes.single.tick, 480);
          expect(notes.single.pitch, 64);
        },
      );

      test(
        'when saving, then notes come back ordered by tick then pitch',
        () async {
          await save([
            note(tick: 960, pitch: 60),
            note(tick: 0, pitch: 67),
            note(tick: 0, pitch: 60),
            note(channel: 2, tick: 480, pitch: 72, velocity: 80),
          ]);

          final notes = await listNotes();

          expect(notes.map((n) => (n.tick, n.pitch)), [
            (0, 60),
            (0, 67),
            (480, 72),
            (960, 60),
          ]);
          expect(notes[2].velocity, 80);
          expect(notes[2].lengthTicks, 240);
        },
      );

      test('when saving an empty list, then all notes are removed', () async {
        await save([note(), note(tick: 240)]);

        await save([]);

        expect(await listNotes(), isEmpty);
      });
    });

    group('pattern changes', () {
      test(
        'when cloning, then the copy gets independent copies of the notes',
        () async {
          await save([note(), note(channel: 1, tick: 960)]);

          final copy = await endpoints.pattern.clone(owner.session, pattern.id);
          final copied = await listNotes(target: copy);

          expect(copied, hasLength(2));
          expect(copied.map((n) => (n.channelId, n.tick)), [
            (channels[0].id, 0),
            (channels[1].id, 960),
          ]);

          await save([note(tick: 240)], target: copy);
          expect(await listNotes(), hasLength(2));
          expect(await listNotes(target: copy), hasLength(1));
        },
      );

      test(
        'when shrinking from 4 bars to 1, then later notes are deleted',
        () async {
          await save([
            note(tick: 0),
            note(tick: 3840 - 240),
            note(tick: 3840),
            note(tick: 3 * 3840),
          ]);

          await endpoints.pattern.update(
            owner.session,
            pattern.id,
            UpdatePatternRequest(
              name: pattern.name,
              colorIndex: pattern.colorIndex,
              lengthBars: 1,
            ),
          );

          final notes = await listNotes();
          expect(notes.map((n) => n.tick), [0, 3840 - 240]);
        },
      );

      test('when growing a pattern, then notes are kept', () async {
        await save([note(tick: 3840)]);

        await endpoints.pattern.update(
          owner.session,
          pattern.id,
          UpdatePatternRequest(
            name: pattern.name,
            colorIndex: pattern.colorIndex,
            lengthBars: 8,
          ),
        );

        expect(await listNotes(), hasLength(1));
      });

      test('when the pattern is deleted, then its notes are deleted', () async {
        final second = await endpoints.pattern.create(
          owner.session,
          CreatePatternRequest(projectId: project.id),
        );
        await save([note(), note(tick: 240)], target: second);

        await endpoints.pattern.delete(owner.session, second.id);

        final remaining = await PatternNote.db.count(
          sessionBuilder.build(),
          where: (t) => t.patternId.equals(second.id),
        );
        expect(remaining, 0);
      });
    });
  });
}
