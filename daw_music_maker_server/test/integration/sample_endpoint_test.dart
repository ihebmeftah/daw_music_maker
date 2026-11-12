import 'dart:typed_data';

import 'package:daw_music_maker_server/src/core/validation/validation_rules.dart';
import 'package:daw_music_maker_server/src/features/samples/services/sample_service.dart';
import 'package:daw_music_maker_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../helpers/wav_builder.dart';
import 'helpers/project_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Sample endpoint', (sessionBuilder, endpoints) {
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

    RequestSampleUploadRequest ticketRequest({
      String fileName = 'kick.wav',
      int sizeBytes = 1000,
      UuidValue? projectId,
    }) => RequestSampleUploadRequest(
      projectId: projectId ?? project.id,
      fileName: fileName,
      sizeBytes: sizeBytes,
    );

    /// Simulates what `FileUploader` does: an unverified file at the path.
    Future<String> putFile(
      UuidValue uploadId,
      Uint8List bytes, {
      AudioFormat format = AudioFormat.wav,
      UuidValue? projectId,
    }) async {
      final path = SampleService.storagePath(
        projectId ?? project.id,
        uploadId,
        format,
      );
      await DatabaseCloudStorage('private').storeUnverifiedFile(
        session: sessionBuilder.build(),
        path: path,
        byteData: ByteData.sublistView(bytes),
      );
      return path;
    }

    Future<bool> fileExists(String path) => sessionBuilder
        .build()
        .storage
        .fileExists(storageId: 'private', path: path);

    /// Full upload flow for [user] (default owner): ticket → file → finish.
    Future<SampleResponse> upload({
      TestUser? user,
      String fileName = 'Big Kick.wav',
      Uint8List? bytes,
      int? durationMs,
    }) async {
      final data = bytes ?? buildWav(samples: sine());
      final ticket = await endpoints.sample.requestUpload(
        (user ?? owner).session,
        ticketRequest(fileName: fileName, sizeBytes: data.length),
      );
      await putFile(
        ticket.uploadId,
        data,
        format: fileName.endsWith('.mp3') ? AudioFormat.mp3 : AudioFormat.wav,
      );
      return endpoints.sample.finishUpload(
        (user ?? owner).session,
        FinishSampleUploadRequest(
          projectId: project.id,
          uploadId: ticket.uploadId,
          fileName: fileName,
          durationMs: durationMs,
        ),
      );
    }

    setUp(() async {
      configureTestAuth();
      owner = await createUser(sessionBuilder, uniqueEmail('owner'));
      other = await createUser(sessionBuilder, uniqueEmail('other'));
      project = await endpoints.project.create(owner.session, createRequest());
    });

    group('requestUpload', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.sample.requestUpload(unauthenticated, ticketRequest()),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user targets a private project, then notFound',
        () async {
          await expectLater(
            endpoints.sample.requestUpload(other.session, ticketRequest()),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a read member asks, then forbidden', () async {
        await addMember(other, ProjectRole.read);

        await expectLater(
          endpoints.sample.requestUpload(other.session, ticketRequest()),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test('when the extension is unsupported, then validation', () async {
        await expectLater(
          endpoints.sample.requestUpload(
            owner.session,
            ticketRequest(fileName: 'song.aiff'),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test('when the size is 0 or above 10 MB, then validation', () async {
        for (final size in [0, ValidationRules.sampleMaxBytes + 1]) {
          await expectLater(
            endpoints.sample.requestUpload(
              owner.session,
              ticketRequest(sizeBytes: size),
            ),
            throwsAppException(ErrorCode.validation),
            reason: '$size',
          );
        }
      });

      test('when exactly 10 MB, then a ticket is issued', () async {
        final ticket = await endpoints.sample.requestUpload(
          owner.session,
          ticketRequest(sizeBytes: ValidationRules.sampleMaxBytes),
        );

        expect(ticket.uploadDescription, isNotEmpty);
      });

      test('when a write member asks, then a ticket is issued', () async {
        await addMember(other, ProjectRole.write);

        final ticket = await endpoints.sample.requestUpload(
          other.session,
          ticketRequest(),
        );

        expect(ticket.uploadId, isNotNull);
      });

      test('when the project has 64 samples, then limitReached', () async {
        final session = sessionBuilder.build();
        for (var i = 0; i < ValidationRules.samplesMax; i++) {
          await Sample.db.insertRow(
            session,
            Sample(
              projectId: project.id,
              name: 's$i',
              format: AudioFormat.wav,
              sizeBytes: 10,
              storagePath: 'test/${project.id}/$i.wav',
              uploadedById: owner.id,
            ),
          );
        }

        await expectLater(
          endpoints.sample.requestUpload(owner.session, ticketRequest()),
          throwsAppException(ErrorCode.limitReached),
        );
      });
    });

    group('finishUpload', () {
      test(
        'when a WAV was uploaded, then registers it with peaks and duration',
        () async {
          final sample = await upload();

          expect(sample.name, 'Big Kick');
          expect(sample.format, AudioFormat.wav);
          expect(sample.durationMs, 1000);
          expect(sample.peaks, hasLength(200));
          expect(sample.url, isNotEmpty);
          expect(sample.projectId, project.id);
        },
      );

      test(
        'when an MP3 was uploaded, then keeps the client duration',
        () async {
          final sample = await upload(
            fileName: 'loop.mp3',
            bytes: Uint8List.fromList([...'ID3'.codeUnits, 0, 0, 0, 0, 0]),
            durationMs: 4200,
          );

          expect(sample.format, AudioFormat.mp3);
          expect(sample.durationMs, 4200);
          expect(sample.peaks, isNull);
        },
      );

      test(
        'when the client duration is out of range, then it is ignored',
        () async {
          final sample = await upload(
            fileName: 'loop.mp3',
            bytes: Uint8List.fromList([0xFF, 0xFB, 0x90, 0]),
            durationMs: ValidationRules.sampleMaxDurationMs + 1,
          );

          expect(sample.durationMs, isNull);
        },
      );

      test(
        'when the bytes do not match the extension, then validation and the file is deleted',
        () async {
          final ticket = await endpoints.sample.requestUpload(
            owner.session,
            ticketRequest(),
          );
          final path = await putFile(
            ticket.uploadId,
            Uint8List.fromList('OggS not a wav'.codeUnits),
          );

          await expectLater(
            endpoints.sample.finishUpload(
              owner.session,
              FinishSampleUploadRequest(
                projectId: project.id,
                uploadId: ticket.uploadId,
                fileName: 'kick.wav',
              ),
            ),
            throwsAppException(ErrorCode.validation),
          );
          expect(await fileExists(path), isFalse);
          expect(
            await endpoints.sample.list(owner.session, project.id),
            isEmpty,
          );
        },
      );

      test('when nothing was uploaded, then validation', () async {
        final ticket = await endpoints.sample.requestUpload(
          owner.session,
          ticketRequest(),
        );

        await expectLater(
          endpoints.sample.finishUpload(
            owner.session,
            FinishSampleUploadRequest(
              projectId: project.id,
              uploadId: ticket.uploadId,
              fileName: 'kick.wav',
            ),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test('when the file name is unsupported, then validation', () async {
        await expectLater(
          endpoints.sample.finishUpload(
            owner.session,
            FinishSampleUploadRequest(
              projectId: project.id,
              uploadId: const Uuid().v4obj(),
              fileName: 'kick.exe',
            ),
          ),
          throwsAppException(ErrorCode.validation),
        );
      });

      test('when finished twice, then returns the same sample', () async {
        final data = buildWav(samples: sine());
        final ticket = await endpoints.sample.requestUpload(
          owner.session,
          ticketRequest(sizeBytes: data.length),
        );
        await putFile(ticket.uploadId, data);
        final request = FinishSampleUploadRequest(
          projectId: project.id,
          uploadId: ticket.uploadId,
          fileName: 'kick.wav',
        );

        final first = await endpoints.sample.finishUpload(
          owner.session,
          request,
        );
        final second = await endpoints.sample.finishUpload(
          owner.session,
          request,
        );

        expect(second.id, first.id);
        expect(
          await endpoints.sample.list(owner.session, project.id),
          hasLength(1),
        );
      });

      test('when unauthenticated or not an editor, then rejected', () async {
        final request = FinishSampleUploadRequest(
          projectId: project.id,
          uploadId: const Uuid().v4obj(),
          fileName: 'kick.wav',
        );
        await expectLater(
          endpoints.sample.finishUpload(unauthenticated, request),
          throwsUnauthenticated,
        );
        await expectLater(
          endpoints.sample.finishUpload(other.session, request),
          throwsAppException(ErrorCode.notFound),
        );
        await addMember(other, ProjectRole.read);
        await expectLater(
          endpoints.sample.finishUpload(other.session, request),
          throwsAppException(ErrorCode.forbidden),
        );
      });
    });

    group('list', () {
      test('when unauthenticated, then it is rejected', () async {
        await expectLater(
          endpoints.sample.list(unauthenticated, project.id),
          throwsUnauthenticated,
        );
      });

      test(
        'when another user lists a private project, then notFound',
        () async {
          await expectLater(
            endpoints.sample.list(other.session, project.id),
            throwsAppException(ErrorCode.notFound),
          );
        },
      );

      test('when a member lists, then gets samples with urls', () async {
        await upload();
        await addMember(other, ProjectRole.read);

        final samples = await endpoints.sample.list(other.session, project.id);

        expect(samples.single.url, isNotEmpty);
        expect(samples.single.name, 'Big Kick');
      });

      test(
        'when a visitor lists a public project, then gets the samples',
        () async {
          await upload();
          await endpoints.project.update(
            owner.session,
            project.id,
            updateRequest(project, visibility: ProjectVisibility.public),
          );

          final samples = await endpoints.sample.list(
            other.session,
            project.id,
          );

          expect(samples, hasLength(1));
        },
      );

      test('when several samples exist, then newest first', () async {
        await upload(fileName: 'first.wav');
        await upload(fileName: 'second.wav');

        final samples = await endpoints.sample.list(owner.session, project.id);

        expect(samples.map((s) => s.name), ['second', 'first']);
      });
    });

    group('delete', () {
      test('when unauthenticated, then it is rejected', () async {
        final sample = await upload();

        await expectLater(
          endpoints.sample.delete(unauthenticated, sample.id),
          throwsUnauthenticated,
        );
      });

      test('when the sample does not exist, then notFound', () async {
        await expectLater(
          endpoints.sample.delete(owner.session, const Uuid().v4obj()),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when another user deletes, then notFound', () async {
        final sample = await upload();

        await expectLater(
          endpoints.sample.delete(other.session, sample.id),
          throwsAppException(ErrorCode.notFound),
        );
      });

      test('when a read member deletes, then forbidden', () async {
        final sample = await upload();
        await addMember(other, ProjectRole.read);

        await expectLater(
          endpoints.sample.delete(other.session, sample.id),
          throwsAppException(ErrorCode.forbidden),
        );
      });

      test(
        'when the editor deletes, then the row, file, channels and clips go',
        () async {
          final sample = await upload();
          final row = await Sample.db.findById(
            sessionBuilder.build(),
            sample.id,
          );
          final channel = await endpoints.channel.create(
            owner.session,
            CreateChannelRequest(projectId: project.id, sampleId: sample.id),
          );
          await endpoints.playlist.save(
            owner.session,
            project.id,
            SavePlaylistRequest(
              clips: [
                ClipInput(
                  sampleId: sample.id,
                  lengthBars: 2,
                  track: 0,
                  startStep: 0,
                ),
              ],
            ),
          );

          await endpoints.sample.delete(owner.session, sample.id);

          expect(
            await endpoints.sample.list(owner.session, project.id),
            isEmpty,
          );
          expect(await fileExists(row!.storagePath), isFalse);
          final channels = await endpoints.channel.list(
            owner.session,
            project.id,
          );
          expect(channels.any((c) => c.id == channel.id), isFalse);
          expect(
            await endpoints.playlist.list(owner.session, project.id),
            isEmpty,
          );
        },
      );
    });

    group('channels and playlist with samples', () {
      test(
        'when creating a channel from a sample, then it is named after it',
        () async {
          final sample = await upload();

          final channel = await endpoints.channel.create(
            owner.session,
            CreateChannelRequest(projectId: project.id, sampleId: sample.id),
          );

          expect(channel.name, 'Big Kick');
          expect(channel.sampleId, sample.id);
          expect(channel.sample, isNull);
          expect(channel.pan, 0);
          expect(channel.pitch, 0);
          expect(channel.startFrac, 0);
          expect(channel.endFrac, 1);
        },
      );

      test(
        'when the sample belongs to another project, then validation',
        () async {
          final sample = await upload();
          final otherProject = await endpoints.project.create(
            other.session,
            createRequest(),
          );

          await expectLater(
            endpoints.channel.create(
              other.session,
              CreateChannelRequest(
                projectId: otherProject.id,
                sampleId: sample.id,
              ),
            ),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when both or neither of sample and sampleId, then validation',
        () async {
          final sample = await upload();

          await expectLater(
            endpoints.channel.create(
              owner.session,
              CreateChannelRequest(
                projectId: project.id,
                sample: SampleKind.kick,
                sampleId: sample.id,
              ),
            ),
            throwsAppException(ErrorCode.validation),
          );
          await expectLater(
            endpoints.channel.create(
              owner.session,
              CreateChannelRequest(projectId: project.id),
            ),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when saving an audio clip of another project\'s sample, then validation',
        () async {
          final otherProject = await endpoints.project.create(
            other.session,
            createRequest(),
          );
          final foreign = await Sample.db.insertRow(
            sessionBuilder.build(),
            Sample(
              projectId: otherProject.id,
              name: 'foreign',
              format: AudioFormat.wav,
              sizeBytes: 10,
              storagePath: 'test/${otherProject.id}/foreign.wav',
              uploadedById: other.id,
            ),
          );

          await expectLater(
            endpoints.playlist.save(
              owner.session,
              project.id,
              SavePlaylistRequest(
                clips: [
                  ClipInput(
                    sampleId: foreign.id,
                    lengthBars: 2,
                    track: 0,
                    startStep: 0,
                  ),
                ],
              ),
            ),
            throwsAppException(ErrorCode.validation),
          );
        },
      );

      test(
        'when saving an audio clip, then it is listed with its length',
        () async {
          final sample = await upload();

          await endpoints.playlist.save(
            owner.session,
            project.id,
            SavePlaylistRequest(
              clips: [
                ClipInput(
                  sampleId: sample.id,
                  lengthBars: 3,
                  track: 1,
                  startStep: 32,
                ),
              ],
            ),
          );

          final clip = (await endpoints.playlist.list(
            owner.session,
            project.id,
          )).single;
          expect(clip.sampleId, sample.id);
          expect(clip.patternId, isNull);
          expect(clip.lengthBars, 3);
        },
      );
    });
  });
}
