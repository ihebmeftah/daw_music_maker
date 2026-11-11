import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/di/injection.dart';

/// Bootstraps DI (Serverpod client + restored session), then runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    ProviderScope(
      // Failures are shown with an explicit "Try again" action instead of
      // silent automatic retries (which would also retry e.g. notFound).
      retry: (retryCount, error) => null,
      child: const DawApp(),
    ),
  );
}
