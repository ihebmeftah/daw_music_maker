import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/layout/panel.dart';
import 'person_tile.dart';
import 'project_labels.dart';

/// Owner-only panel: accept or decline people asking to join.
class JoinRequestsPanel extends StatelessWidget {
  /// Creates the panel.
  const JoinRequestsPanel({
    super.key,
    required this.requests,
    required this.onRespond,
  });

  /// Key of the accept button for [requestId].
  static Key acceptKey(UuidValue requestId) =>
      Key('joinRequests.accept.$requestId');

  /// Key of the decline button for [requestId].
  static Key declineKey(UuidValue requestId) =>
      Key('joinRequests.decline.$requestId');

  /// Pending requests.
  final List<JoinRequestResponse> requests;

  /// Accepts (`true`) or declines (`false`) a request.
  final void Function(JoinRequestResponse request, bool accept) onRespond;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Panel(
      eyebrow: 'JOIN REQUESTS',
      title: requests.isEmpty
          ? 'No one is knocking'
          : '${requests.length} waiting',
      child: Column(
        children: [
          for (final r in requests)
            PersonTile(
              title: r.email ?? 'A producer',
              subtitle: 'Asks for ${r.role.label.toLowerCase()} access',
              trailing: [
                IconButton(
                  key: declineKey(r.id),
                  tooltip: 'Decline',
                  icon: Icon(Icons.close_rounded, color: colors.error),
                  onPressed: () => onRespond(r, false),
                ),
                IconButton(
                  key: acceptKey(r.id),
                  tooltip: 'Accept',
                  icon: Icon(
                    Icons.check_rounded,
                    color: context.dawColors.meterLow,
                  ),
                  onPressed: () => onRespond(r, true),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
