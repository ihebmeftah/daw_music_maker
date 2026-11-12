import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../state/sample_upload.dart';
import 'browser_item.dart';
import 'channel_rack.dart' show sampleLabel;

/// Callbacks of the [SampleBrowser].
class SampleBrowserActions {
  /// Creates the callbacks.
  const SampleBrowserActions({
    required this.onUpload,
    required this.onPreview,
    required this.onOpen,
    required this.onDelete,
    required this.onDismissUpload,
  });

  /// Pick files to upload.
  final VoidCallback onUpload;

  /// Play an item.
  final ValueChanged<BrowserItem> onPreview;

  /// Double-click: add the item as a channel and open its sampler.
  final ValueChanged<BrowserItem> onOpen;

  /// Delete an uploaded sample.
  final ValueChanged<UuidValue> onDelete;

  /// Dismiss a finished / failed upload entry.
  final ValueChanged<int> onDismissUpload;
}

/// FL-style browser: built-in drums and the project's uploaded samples.
/// Items can be dragged onto the channel rack (new channel) or the playlist
/// (audio clip); tap previews, double-tap opens the sampler.
class SampleBrowser extends StatelessWidget {
  /// Creates the browser.
  const SampleBrowser({
    super.key,
    required this.samples,
    required this.uploads,
    required this.canEdit,
    required this.actions,
  });

  /// Key of the upload button.
  static const uploadKey = Key('browser.upload');

  /// Key of the built-in item [kind].
  static Key builtinKey(SampleKind kind) => Key('browser.builtin.${kind.name}');

  /// Key of the uploaded item [id].
  static Key sampleKey(UuidValue id) => Key('browser.sample.$id');

  /// Key of the delete button of the uploaded item [id].
  static Key deleteKey(UuidValue id) => Key('browser.delete.$id');

  /// Width of the browser.
  static const double width = 210;

  /// Uploaded samples.
  final List<SampleResponse> samples;

  /// Uploads in progress / failed.
  final List<SampleUpload> uploads;

  /// Whether the user may upload / delete.
  final bool canEdit;

  /// Callbacks.
  final SampleBrowserActions actions;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.dawColors.panel,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: context.dawColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'BROWSER',
                  style: styles.eyebrow.copyWith(color: colors.primary),
                ),
              ),
              if (canEdit)
                IconButton(
                  key: uploadKey,
                  tooltip: 'Upload audio (WAV, MP3, OGG, FLAC · max 10 MB)',
                  visualDensity: VisualDensity.compact,
                  onPressed: actions.onUpload,
                  icon: const Icon(Icons.upload_file_rounded),
                ),
            ],
          ),
          for (final upload in uploads)
            _UploadTile(upload: upload, actions: actions),
          Expanded(
            child: ListView(
              children: [
                const _Section(label: 'DRUMS'),
                for (final kind in SampleKind.values)
                  _Item(
                    key: builtinKey(kind),
                    item: BrowserItem.builtin(kind),
                    label: sampleLabel(kind),
                    icon: Icons.album_rounded,
                    actions: actions,
                  ),
                const _Section(label: 'SAMPLES'),
                if (samples.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Text(
                      canEdit
                          ? 'Drop audio files here or use ⬆ to upload.'
                          : 'No samples yet.',
                      style: styles.bodySmall,
                    ),
                  ),
                for (final s in samples)
                  _Item(
                    key: sampleKey(s.id),
                    item: BrowserItem.uploaded(s.id),
                    label: s.name,
                    subtitle:
                        '${s.format.name.toUpperCase()} · ${_size(s.sizeBytes)}',
                    icon: Icons.graphic_eq_rounded,
                    actions: actions,
                    onDelete: canEdit ? () => actions.onDelete(s.id) : null,
                    deleteKey: deleteKey(s.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _size(int bytes) => bytes >= 1024 * 1024
      ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'
      : '${(bytes / 1024).ceil()} KB';
}

class _Section extends StatelessWidget {
  const _Section({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: context.textStyles.eyebrow.copyWith(fontSize: 9),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.item,
    required this.label,
    required this.icon,
    required this.actions,
    this.subtitle,
    this.onDelete,
    this.deleteKey,
  });

  final BrowserItem item;
  final String label;
  final String? subtitle;
  final IconData icon;
  final SampleBrowserActions actions;
  final VoidCallback? onDelete;
  final Key? deleteKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    // The delete button sits outside the tap / double-tap area so it reacts
    // immediately (no wait for a possible double-tap).
    final tile = Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => actions.onPreview(item),
            onDoubleTap: () => actions.onOpen(item),
            borderRadius: AppRadii.smAll,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.label.copyWith(fontSize: 12),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: styles.eyebrow.copyWith(fontSize: 8),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (onDelete != null)
          IconButton(
            key: deleteKey,
            tooltip: 'Delete sample',
            visualDensity: VisualDensity.compact,
            iconSize: 16,
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
      ],
    );
    return Draggable<BrowserItem>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        color: colors.primary,
        borderRadius: AppRadii.smAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: styles.label.copyWith(color: colors.onPrimary),
          ),
        ),
      ),
      child: tile,
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.upload, required this.actions});

  final SampleUpload upload;
  final SampleBrowserActions actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final failed = upload.error != null;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  upload.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodySmall,
                ),
              ),
              if (failed)
                IconButton(
                  tooltip: 'Dismiss',
                  visualDensity: VisualDensity.compact,
                  iconSize: 14,
                  onPressed: () => actions.onDismissUpload(upload.id),
                  icon: const Icon(Icons.close_rounded),
                )
              else
                Text(
                  '${(upload.progress * 100).round()}%',
                  style: styles.mono.copyWith(fontSize: 10),
                ),
            ],
          ),
          if (failed)
            Text(
              upload.error!,
              style: styles.bodySmall.copyWith(color: colors.error),
            )
          else
            Semantics(
              label: 'Uploading ${upload.fileName}',
              value: '${(upload.progress * 100).round()}%',
              child: LinearProgressIndicator(
                value: upload.progress,
                borderRadius: AppRadii.smAll,
              ),
            ),
        ],
      ),
    );
  }
}
