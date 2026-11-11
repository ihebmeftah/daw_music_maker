import 'dart:async';

import 'package:daw_music_maker/core/theme/app_text_styles.dart';

/// Global test setup: never fetch Google Fonts over the network in tests.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  AppFonts.useGoogleFonts = false;
  await testMain();
}
