import 'package:daw_music_maker/app/app.dart';
import 'package:daw_music_maker/app/router/app_router.dart';
import 'package:daw_music_maker/core/auth/auth_session_provider.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_provider.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/auth_hero.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/code_step_form.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/email_step_form.dart';
import 'package:daw_music_maker/features/auth/presentation/widgets/spectrum_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// Layout tests for the auth shell at phone and desktop widths.
void main() {
  setUpAll(registerTestFallbacks);

  Future<ProviderContainer> pumpAt(
    WidgetTester tester,
    Size size,
    MockAuthRepository repository, {
    String location = '/login',
  }) async {
    prepareSurface(tester, size: size);
    final container = ProviderContainer(
      overrides: [
        authSessionProvider.overrideWithValue(FakeAuthSession()),
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const DawApp()),
    );
    container.read(appRouterProvider).go(location);
    await tester.pumpAndSettle();
    return container;
  }

  group('Given the auth shell', () {
    testWidgets('when on a desktop, then shows the full hero beside the form', (
      tester,
    ) async {
      await pumpAt(tester, const Size(1400, 1000), MockAuthRepository());

      expect(find.byType(SpectrumBars), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when on a phone, then stacks a compact hero without overflow',
      (
        tester,
      ) async {
        await pumpAt(tester, const Size(360, 780), MockAuthRepository());

        expect(find.byType(AuthHero), findsOneWidget);
        expect(find.byType(SpectrumBars), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when the code step is shown on a phone, then nothing overflows',
      (
        tester,
      ) async {
        final repository = MockAuthRepository();
        when(
          () => repository.startRegistration(email: any(named: 'email')),
        ).thenAnswer((_) async => testRequestId);
        await pumpAt(
          tester,
          const Size(360, 780),
          repository,
          location: '/register',
        );

        await tester.enterText(
          find.byKey(EmailStepForm.emailFieldKey),
          'a-rather-long-address@some-studio.fm',
        );
        await tester.ensureVisible(find.byKey(EmailStepForm.submitKey));
        await tester.tap(find.byKey(EmailStepForm.submitKey));
        await tester.pumpAndSettle();

        expect(find.byKey(CodeStepForm.codeFieldKey), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when in light mode, then renders without errors', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await pumpAt(tester, const Size(1400, 1000), MockAuthRepository());

      final context = tester.element(find.byType(AuthHero));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(tester.takeException(), isNull);
    });
  });
}
