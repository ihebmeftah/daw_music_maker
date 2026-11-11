import 'package:flutter/material.dart';

import '../../../core/errors/failure.dart';
import '../buttons/daw_button.dart';
import 'empty_state.dart';

/// Full-area error with the failure's friendly message and a retry action.
///
/// ```dart
/// ErrorView(failure: failure, onRetry: viewModel.refresh)
/// ```
class ErrorView extends StatelessWidget {
  /// Creates an error view for [error] (a [Failure] or anything else).
  const ErrorView({super.key, required this.error, this.onRetry});

  /// The error; non-[Failure] errors show a generic message.
  final Object error;

  /// Called by the "Try again" button (hidden when null).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final failure = error is Failure
        ? error as Failure
        : const Failure(FailureCode.unknown);
    return EmptyState(
      icon: failure.code == FailureCode.network
          ? Icons.wifi_off_rounded
          : Icons.graphic_eq_rounded,
      title: failure.code == FailureCode.notFound
          ? 'Nothing here'
          : 'Signal lost',
      message: failure.message,
      action: onRetry == null
          ? null
          : DawButton(
              label: 'Try again',
              icon: Icons.refresh_rounded,
              variant: DawButtonVariant.ghost,
              onPressed: onRetry,
            ),
    );
  }
}
