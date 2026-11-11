import 'package:flutter/material.dart';

import '../../../core/errors/failure.dart';
import 'error_view.dart';

/// Screen shown for unknown routes or invalid ids in a URL.
///
/// ```dart
/// const NotFoundView()
/// ```
class NotFoundView extends StatelessWidget {
  /// Creates the view.
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ErrorView(error: Failure(FailureCode.notFound)),
    );
  }
}
