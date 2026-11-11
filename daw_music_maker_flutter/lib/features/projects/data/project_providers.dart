import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/di/injection.dart';
import 'collaboration_repository.dart';
import 'project_repository.dart';

part 'project_providers.g.dart';

/// Exposes the [ProjectRepository] registered in get_it to Riverpod.
@Riverpod(keepAlive: true)
ProjectRepository projectRepository(Ref ref) => getIt<ProjectRepository>();

/// Exposes the [CollaborationRepository] registered in get_it to Riverpod.
@Riverpod(keepAlive: true)
CollaborationRepository collaborationRepository(Ref ref) =>
    getIt<CollaborationRepository>();
