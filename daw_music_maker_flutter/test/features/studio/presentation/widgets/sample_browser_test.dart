import 'package:daw_music_maker/features/studio/presentation/state/sample_upload.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/browser_item.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/sample_browser.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late List<String> calls;
  final voxId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f11');
  final vox = testSample(id: voxId, name: 'Vox Chop', format: AudioFormat.mp3);

  setUp(() => calls = []);

  String describe(BrowserItem item) =>
      item.kind?.name ?? (item.sampleId == voxId ? 'vox' : '?');

  Future<void> pump(
    WidgetTester tester, {
    bool canEdit = true,
    List<SampleResponse>? samples,
    List<SampleUpload> uploads = const [],
  }) => tester.pumpApp(
    SizedBox(
      height: 700,
      child: Align(
        alignment: Alignment.topLeft,
        child: SampleBrowser(
          samples: samples ?? [vox],
          uploads: uploads,
          canEdit: canEdit,
          actions: SampleBrowserActions(
            onUpload: () => calls.add('upload'),
            onPreview: (i) => calls.add('preview ${describe(i)}'),
            onOpen: (i) => calls.add('open ${describe(i)}'),
            onDelete: (id) => calls.add('delete ${id == voxId}'),
            onDismissUpload: (id) => calls.add('dismiss $id'),
          ),
        ),
      ),
    ),
  );

  group('Given a SampleBrowser', () {
    testWidgets('when rendered, then lists the drums and uploaded samples', (
      tester,
    ) async {
      await pump(tester);

      for (final label in ['Kick', 'Snare', 'Closed hat', 'Open hat']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('Vox Chop'), findsOneWidget);
      expect(find.text('MP3 · 2 KB'), findsOneWidget);
    });

    testWidgets('when there are no samples, then explains how to add some', (
      tester,
    ) async {
      await pump(tester, samples: const []);

      expect(
        find.text('Drop audio files here or use ⬆ to upload.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'when uploading, then shows progress; failures can be dismissed',
      (
        tester,
      ) async {
        await pump(
          tester,
          uploads: const [
            SampleUpload(id: 1, fileName: 'pad.wav', progress: 0.5),
            SampleUpload(id: 2, fileName: 'x.txt', error: 'Use a WAV file'),
          ],
        );

        expect(find.text('50%'), findsOneWidget);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          0.5,
        );
        expect(find.text('Use a WAV file'), findsOneWidget);

        await tester.tap(find.byTooltip('Dismiss'));

        expect(calls, ['dismiss 2']);
      },
    );

    testWidgets(
      'when tapping and double-tapping items, then previews and opens',
      (
        tester,
      ) async {
        await pump(tester);

        await tester.tap(
          find.byKey(SampleBrowser.builtinKey(SampleKind.snare)),
        );
        await tester.pump(kDoubleTapTimeout);
        final sample = find.byKey(SampleBrowser.sampleKey(voxId));
        await tester.tap(sample);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(sample);
        await tester.pumpAndSettle();

        expect(calls, ['preview snare', 'open vox']);
      },
    );

    testWidgets('when an editor uses the buttons, then uploads and deletes', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(SampleBrowser.uploadKey));
      // The item also listens for double-taps, so a single tap resolves
      // once the double-tap window has passed.
      await tester.tap(find.byKey(SampleBrowser.deleteKey(voxId)));
      await tester.pump(kDoubleTapTimeout);

      expect(calls, ['upload', 'delete true']);
    });

    testWidgets('when read-only, then there is no upload or delete', (
      tester,
    ) async {
      await pump(tester, canEdit: false);

      expect(find.byKey(SampleBrowser.uploadKey), findsNothing);
      expect(find.byKey(SampleBrowser.deleteKey(voxId)), findsNothing);
      expect(find.text('No samples yet.'), findsNothing);
    });

    testWidgets('when rendered, then every item can be dragged', (
      tester,
    ) async {
      await pump(tester);

      final draggables = tester
          .widgetList<Draggable<BrowserItem>>(
            find.byType(Draggable<BrowserItem>),
          )
          .toList();
      expect(draggables, hasLength(5));
      expect(draggables.last.data!.sampleId, voxId);
      expect(draggables.first.data!.kind, SampleKind.kick);
    });
  });
}
