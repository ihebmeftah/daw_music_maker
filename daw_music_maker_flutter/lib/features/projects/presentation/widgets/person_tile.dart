import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// A row for a person (member, invitee or requester): initial avatar, name
/// line, subtitle and trailing actions.
class PersonTile extends StatelessWidget {
  /// Creates the tile.
  const PersonTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing = const [],
    this.highlight = false,
  });

  /// Main line (usually an email).
  final String title;

  /// Secondary line (role, date…).
  final String subtitle;

  /// Actions on the right.
  final List<Widget> trailing;

  /// Accent the avatar (e.g. for the owner).
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    final initial = title.isEmpty ? '?' : title[0].toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: highlight
                ? daw.waveStart
                : colors.surfaceContainerHighest,
            child: Text(
              initial,
              style: context.textStyles.label.copyWith(
                color: highlight ? colors.onPrimary : colors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.title,
                ),
                Text(subtitle, style: context.textStyles.bodySmall),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
