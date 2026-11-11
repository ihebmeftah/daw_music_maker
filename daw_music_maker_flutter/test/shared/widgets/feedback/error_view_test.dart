import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/shared/widgets/feedback/error_view.dart';
import 'package:daw_music_maker/shared/widgets/feedback/loading_view.dart';
import 'package:daw_music_maker/shared/widgets/feedback/not_found_view.dart';
import 'package:daw_music_maker/shared/widgets/feedback/equalizer_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given an ErrorView', () {
    testWidgets('when given a Failure, then shows its friendly message', (
      tester,
    ) async {
      await tester.pumpApp(
        const ErrorView(error: Failure(FailureCode.network)),
      );

      expect(find.text(FailureCode.network.message), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text('TRY AGAIN'), findsNothing);
    });

    testWidgets('when given another error, then shows a generic message', (
      tester,
    ) async {
      await tester.pumpApp(ErrorView(error: StateError('internal details')));

      expect(find.text(FailureCode.unknown.message), findsOneWidget);
      expect(find.textContaining('internal details'), findsNothing);
    });

    testWidgets('when retry is tapped, then calls onRetry', (tester) async {
      var retried = 0;
      await tester.pumpApp(
        ErrorView(
          error: const Failure(FailureCode.unknown),
          onRetry: () => retried++,
        ),
      );

      await tester.tap(find.text('TRY AGAIN'));

      expect(retried, 1);
    });
  });

  group('Given a LoadingView', () {
    testWidgets('when rendered, then shows the equalizer', (tester) async {
      await tester.pumpApp(const LoadingView());

      expect(find.byType(EqualizerLoader), findsOneWidget);
    });
  });

  group('Given a NotFoundView', () {
    testWidgets('when rendered, then says nothing is here', (tester) async {
      await tester.pumpApp(const NotFoundView());

      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
}
