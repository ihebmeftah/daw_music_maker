import 'package:daw_music_maker/features/studio/presentation/widgets/channel_rack.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/sampler_dialog.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockStudioRepository studio;
  late FakeAudioEngine audio;

  final voxId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f21');
  final channelId = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f22',
  );

  ChannelResponse voxChannel() => ChannelResponse(
    id: channelId,
    projectId: testRequestId,
    name: 'Vox',
    sampleId: voxId,
    volume: 0.5,
    muted: false,
    pan: 0,
    pitch: 0,
    startFrac: 0.25,
    endFrac: 0.75,
    position: 0,
  );

  setUpAll(registerTestFallbacks);

  setUp(() {
    studio = MockStudioRepository();
    audio = FakeAudioEngine();
    when(
      () => studio.updateChannel(
        any(),
        name: any(named: 'name'),
        volume: any(named: 'volume'),
        muted: any(named: 'muted'),
        pan: any(named: 'pan'),
        pitch: any(named: 'pitch'),
        startFrac: any(named: 'startFrac'),
        endFrac: any(named: 'endFrac'),
      ),
    ).thenAnswer(
      (inv) async => voxChannel().copyWith(
        volume: inv.namedArguments[#volume] as double,
        pan: inv.namedArguments[#pan] as double,
        pitch: inv.namedArguments[#pitch] as int,
        startFrac: inv.namedArguments[#startFrac] as double,
        endFrac: inv.namedArguments[#endFrac] as double,
      ),
    );
  });

  Future<void> openSampler(
    WidgetTester tester, {
    ProjectAccess access = ProjectAccess.owner,
    SampleResponse? sample,
  }) async {
    stubPatterns(
      studio,
      null,
      [voxChannel()],
      const [],
      const [],
      [
        sample ?? testSample(id: voxId, name: 'Vox Take'),
      ],
    );
    when(
      () => studio.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access));
    await tester.pumpDawApp(
      session: FakeAuthSession(signedIn: true),
      studio: studio,
      audio: audio,
      initialLocation: '/projects/$testRequestId/studio',
    );
    final name = find.byKey(ChannelRack.channelKey(channelId));
    await tester.tap(name);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(name);
    await tester.pumpAndSettle();
  }

  /// Captured settings of the last updateChannel call.
  Map<Symbol, dynamic> lastSaved() {
    final inv = verify(
      () => studio.updateChannel(
        channelId,
        name: captureAny(named: 'name'),
        volume: captureAny(named: 'volume'),
        muted: captureAny(named: 'muted'),
        pan: captureAny(named: 'pan'),
        pitch: captureAny(named: 'pitch'),
        startFrac: captureAny(named: 'startFrac'),
        endFrac: captureAny(named: 'endFrac'),
      ),
    ).captured;
    final last = inv.sublist(inv.length - 7);
    return {
      #name: last[0],
      #volume: last[1],
      #muted: last[2],
      #pan: last[3],
      #pitch: last[4],
      #startFrac: last[5],
      #endFrac: last[6],
    };
  }

  group('Given the sampler of an uploaded sample', () {
    testWidgets('when double-clicking a channel, then the sampler opens', (
      tester,
    ) async {
      await openSampler(tester);

      expect(find.byType(SamplerDialog), findsOneWidget);
      expect(find.text('SAMPLER'), findsOneWidget);
      expect(find.text('Vox Take · WAV'), findsOneWidget);
      expect(find.byKey(SamplerDialog.waveKey), findsOneWidget);
      expect(find.textContaining('25%–75%'), findsOneWidget);
    });

    testWidgets(
      'when dragging the start handle, then trims and saves on release',
      (
        tester,
      ) async {
        await openSampler(tester);
        final wave = tester.getRect(find.byKey(SamplerDialog.waveKey));

        await tester.dragFrom(
          Offset(wave.left + wave.width * 0.25, wave.center.dy),
          Offset(-wave.width * 0.15, 0),
        );
        await tester.pumpAndSettle();

        final saved = lastSaved();
        expect(saved[#startFrac] as double, closeTo(0.1, 0.03));
        expect(saved[#endFrac], 0.75);
        expect(find.textContaining('–75%'), findsOneWidget);
      },
    );

    testWidgets(
      'when moving the sliders, then volume, pan and pitch are saved',
      (
        tester,
      ) async {
        await openSampler(tester);

        Future<void> tapAt(Key key, double fraction) async {
          final slider = find.descendant(
            of: find.byKey(key),
            matching: find.byType(Slider),
          );
          final rect = tester.getRect(slider);
          await tester.tapAt(
            Offset(rect.left + rect.width * fraction, rect.center.dy),
          );
          await tester.pumpAndSettle();
        }

        await tapAt(SamplerDialog.volumeKey, 0.9);
        expect(lastSaved()[#volume] as double, greaterThan(0.7));

        await tapAt(SamplerDialog.panKey, 0.9);
        expect(lastSaved()[#pan] as double, greaterThan(0.5));
        expect(find.textContaining('R'), findsWidgets);

        await tapAt(SamplerDialog.pitchKey, 0.1);
        expect(lastSaved()[#pitch] as int, lessThan(-15));
      },
    );

    testWidgets('when previewing, then plays the trimmed region', (
      tester,
    ) async {
      await openSampler(tester);
      audio.samples.clear();

      await tester.tap(find.byKey(SamplerDialog.previewKey));
      await tester.pump();

      expect(audio.samples.single.sampleId, voxId);
      expect(audio.samples.single.startFrac, 0.25);
      expect(audio.samples.single.endFrac, 0.75);
    });

    testWidgets('when chopping into 8, then asks the server and closes', (
      tester,
    ) async {
      when(() => studio.chopChannel(any(), any())).thenAnswer(
        (_) async => [
          for (var i = 0; i < 8; i++)
            voxChannel().copyWith(
              id: UuidValue.fromString(
                '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f3$i',
              ),
              name: 'Vox ${i + 1}',
              position: i + 1,
            ),
        ],
      );
      await openSampler(tester);

      await tester.tap(find.byKey(SamplerDialog.slicesKey(8)));
      await tester.pump();
      await tester.tap(find.byKey(SamplerDialog.chopKey));
      await tester.pumpAndSettle();

      verify(() => studio.chopChannel(channelId, 8)).called(1);
      expect(find.byType(SamplerDialog), findsNothing);
      expect(find.text('Vox 8'), findsOneWidget);
    });
  });

  group('Given the sampler for a read member', () {
    testWidgets('when opened, then chop is hidden and sliders are disabled', (
      tester,
    ) async {
      await openSampler(tester, access: ProjectAccess.read);

      expect(
        find.descendant(
          of: find.byType(SamplerDialog),
          matching: find.text('READ ONLY'),
        ),
        findsOneWidget,
      );
      expect(find.byKey(SamplerDialog.chopKey), findsNothing);
      final slider = tester.widget<Slider>(
        find.descendant(
          of: find.byKey(SamplerDialog.volumeKey),
          matching: find.byType(Slider),
        ),
      );
      expect(slider.onChanged, isNull);
    });
  });

  group('Given an MP3 sample without a waveform', () {
    testWidgets('when opened, then explains there is no preview', (
      tester,
    ) async {
      await openSampler(
        tester,
        sample: testSample(
          id: voxId,
          name: 'Loop',
          format: AudioFormat.mp3,
          peaks: null,
        ),
      );

      expect(find.text('No waveform preview for this format'), findsOneWidget);
      expect(find.text('Loop · MP3'), findsOneWidget);
    });
  });
}
