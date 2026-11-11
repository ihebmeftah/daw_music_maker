import 'package:daw_music_maker/app/app.dart';
import 'package:daw_music_maker/app/router/app_router.dart';
import 'package:daw_music_maker/core/auth/auth_session_provider.dart';
import 'package:daw_music_maker/core/theme/app_theme.dart';
import 'package:daw_music_maker/features/auth/data/auth_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

/// Sets a desktop-sized surface and turns on "reduce motion" so infinite
/// decorative animations (waves, spectrum, transport) stop and
/// `pumpAndSettle` can settle.
void prepareSurface(WidgetTester tester, {Size size = const Size(1400, 1100)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
  });
}

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a themed [MaterialApp] and [ProviderScope].
  Future<void> pumpApp(
    Widget child, {
    List<Override> overrides = const [],
    ThemeData? theme,
  }) async {
    prepareSurface(this);
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: theme ?? AppTheme.dark,
          home: Scaffold(body: child),
        ),
      ),
    );
    await pump();
  }

  /// Pumps the whole [DawApp] (real router + auth guard) at
  /// [initialLocation], with a fake session and a mocked repository.
  ///
  /// Returns the [ProviderContainer] for reading providers in assertions.
  Future<ProviderContainer> pumpDawApp({
    required FakeAuthSession session,
    required MockAuthRepository repository,
    String? initialLocation,
  }) async {
    prepareSurface(this);
    final container = ProviderContainer(
      overrides: [
        authSessionProvider.overrideWithValue(session),
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await pumpWidget(
      UncontrolledProviderScope(container: container, child: const DawApp()),
    );
    if (initialLocation != null) {
      container.read(appRouterProvider).go(initialLocation);
    }
    await pumpAndSettle();
    return container;
  }
}
