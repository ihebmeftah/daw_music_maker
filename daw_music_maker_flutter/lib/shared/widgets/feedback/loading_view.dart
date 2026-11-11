import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';
import 'equalizer_loader.dart';

/// Full-area loading indicator (a centered equalizer).
///
/// ```dart
/// const LoadingView()
/// ```
class LoadingView extends StatelessWidget {
  /// Creates the loading view.
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EqualizerLoader(
        color: context.colors.primary,
        bars: 5,
        height: 28,
      ),
    );
  }
}
