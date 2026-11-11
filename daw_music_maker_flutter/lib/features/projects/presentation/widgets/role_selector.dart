import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import 'project_labels.dart';

/// Read / write selector with a one-line explanation of the chosen role.
class RoleSelector extends StatelessWidget {
  /// Creates the selector.
  const RoleSelector({
    super.key,
    required this.role,
    required this.onChanged,
  });

  /// Key of the "Read" option.
  static const readKey = Key('roleSelector.read');

  /// Key of the "Write" option.
  static const writeKey = Key('roleSelector.write');

  /// Selected role.
  final ProjectRole role;

  /// Called with the new role (disabled when null).
  final ValueChanged<ProjectRole>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DawSegmentedControl<ProjectRole>(
          selected: role,
          onChanged: onChanged,
          segments: [
            DawSegment(
              key: readKey,
              value: ProjectRole.read,
              label: ProjectRole.read.label,
              icon: ProjectRole.read.icon,
            ),
            DawSegment(
              key: writeKey,
              value: ProjectRole.write,
              label: ProjectRole.write.label,
              icon: ProjectRole.write.icon,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(role.description, style: context.textStyles.bodySmall),
      ],
    );
  }
}
