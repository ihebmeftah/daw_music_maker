import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';
import '../../../../shared/widgets/layout/panel.dart';
import '../../../../shared/widgets/layout/studio_scaffold.dart';
import '../state/project_form_state.dart';
import '../view_models/project_form_view_model.dart';
import '../widgets/genre_tags_field.dart';
import '../widgets/project_labels.dart';

/// `/projects/form` (create) and `/projects/form?id=<uuid>` (edit).
class ProjectFormView extends ConsumerWidget {
  /// Creates the view; [projectId] is null when creating.
  const ProjectFormView({super.key, this.projectId});

  /// Key of the name field.
  static const nameFieldKey = Key('projectForm.name');

  /// Key of the description field.
  static const descriptionFieldKey = Key('projectForm.description');

  /// Key of the save button.
  static const saveKey = Key('projectForm.save');

  /// Key of the public visibility option.
  static const publicKey = Key('projectForm.public');

  /// Key of the contributions switch.
  static const contributionsKey = Key('projectForm.contributions');

  /// The project to edit, or null to create one.
  final UuidValue? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = projectFormViewModelProvider(projectId);
    return StudioScaffold(
      title: projectId == null ? 'NEW PROJECT' : 'EDIT PROJECT',
      // Editing goes back to the project; creating goes back to the list.
      onBack: projectId == null
          ? null
          : () => ProjectDetailRoute(id: projectId.toString()).go(context),
      maxWidth: 720,
      body: switch (ref.watch(provider)) {
        AsyncData(:final value) => _ProjectForm(
          projectId: projectId,
          state: value,
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(provider),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _ProjectForm extends ConsumerStatefulWidget {
  const _ProjectForm({required this.projectId, required this.state});

  final UuidValue? projectId;
  final ProjectFormState state;

  @override
  ConsumerState<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<_ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.state.initial?.name);
  late final _description = TextEditingController(
    text: widget.state.initial?.description,
  );
  late List<String> _genres = [...?widget.state.initial?.genres];
  late ProjectVisibility _visibility =
      widget.state.initial?.visibility ?? ProjectVisibility.private;
  late bool _allowContributions =
      widget.state.initial?.allowContributions ?? false;

  /// Only the owner may change visibility and contributions.
  bool get _canChangeSettings =>
      widget.state.initial == null ||
      widget.state.initial!.access == ProjectAccess.owner;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _edited() => ref
      .read(projectFormViewModelProvider(widget.projectId).notifier)
      .clearFailure();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await ref
        .read(projectFormViewModelProvider(widget.projectId).notifier)
        .submit(
          name: _name.text,
          description: _description.text,
          genres: _genres,
          visibility: _visibility,
          allowContributions: _allowContributions,
        );
    if (!mounted) return;
    if (saved == null) {
      // Show server field errors once the new state has been built.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _formKey.currentState?.validate(),
      );
      return;
    }
    // Land on the project's page; the URL becomes /projects/<id>.
    ProjectDetailRoute(id: saved.id.toString()).go(context);
  }

  @override
  Widget build(BuildContext context) {
    final failure = widget.state.failure;
    final submitting = widget.state.isSubmitting;
    final styles = context.textStyles;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          StaggeredReveal(
            index: 0,
            child: Text(
              widget.projectId == null ? 'Start a session' : 'Tweak the mix',
              style: styles.display,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ErrorBanner(message: failure?.message),
          StaggeredReveal(
            index: 1,
            child: Panel(
              eyebrow: 'CH 01 — DETAILS',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DawTextField(
                    key: ProjectFormView.nameFieldKey,
                    label: 'Name',
                    hint: 'Midnight Drive',
                    controller: _name,
                    maxLength: ValidationRules.projectNameMaxLength,
                    textInputAction: TextInputAction.next,
                    enabled: !submitting,
                    validator: (v) =>
                        Validators.projectName(v) ??
                        failure?.fieldError('name'),
                    onChanged: (_) => _edited(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DawTextField(
                    key: ProjectFormView.descriptionFieldKey,
                    label: 'Description',
                    hint: 'What is this track about?',
                    controller: _description,
                    maxLength: ValidationRules.projectDescriptionMaxLength,
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    enabled: !submitting,
                    validator: (v) =>
                        Validators.projectDescription(v) ??
                        failure?.fieldError('description'),
                    onChanged: (_) => _edited(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GenreTagsField(
                    genres: _genres,
                    enabled: !submitting,
                    serverError: failure?.fieldError('genres'),
                    onChanged: (genres) {
                      setState(() => _genres = genres);
                      _edited();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          StaggeredReveal(
            index: 2,
            child: Panel(
              eyebrow: 'CH 02 — SHARING',
              child: _SharingSettings(
                enabled: !submitting && _canChangeSettings,
                visibility: _visibility,
                allowContributions: _allowContributions,
                onVisibilityChanged: (v) => setState(() => _visibility = v),
                onContributionsChanged: (v) =>
                    setState(() => _allowContributions = v),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DawButton(
            key: ProjectFormView.saveKey,
            label: widget.projectId == null ? 'Create project' : 'Save changes',
            icon: Icons.check_rounded,
            isLoading: submitting,
            onPressed: _save,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SharingSettings extends StatelessWidget {
  const _SharingSettings({
    required this.enabled,
    required this.visibility,
    required this.allowContributions,
    required this.onVisibilityChanged,
    required this.onContributionsChanged,
  });

  final bool enabled;
  final ProjectVisibility visibility;
  final bool allowContributions;
  final ValueChanged<ProjectVisibility> onVisibilityChanged;
  final ValueChanged<bool> onContributionsChanged;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DawSegmentedControl<ProjectVisibility>(
          selected: visibility,
          onChanged: enabled ? onVisibilityChanged : null,
          segments: [
            DawSegment(
              value: ProjectVisibility.private,
              label: ProjectVisibility.private.label,
              icon: ProjectVisibility.private.icon,
            ),
            DawSegment(
              key: ProjectFormView.publicKey,
              value: ProjectVisibility.public,
              label: ProjectVisibility.public.label,
              icon: ProjectVisibility.public.icon,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          visibility == ProjectVisibility.public
              ? 'Every producer can discover and open this project.'
              : 'Only you and your collaborators can see this project.',
          style: styles.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          key: ProjectFormView.contributionsKey,
          contentPadding: EdgeInsets.zero,
          value: allowContributions,
          onChanged: enabled ? onContributionsChanged : null,
          title: Text('Open to contributors', style: styles.title),
          subtitle: Text(
            visibility == ProjectVisibility.public
                ? 'You can invite people, and others can ask to join.'
                : 'You can invite people by email.',
            style: styles.bodySmall,
          ),
        ),
        if (!enabled)
          Text(
            'Only the owner can change sharing settings.',
            style: styles.bodySmall,
          ),
      ],
    );
  }
}
