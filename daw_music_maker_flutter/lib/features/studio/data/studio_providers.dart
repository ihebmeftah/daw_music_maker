import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/di/injection.dart';
import 'studio_repository.dart';

part 'studio_providers.g.dart';

/// Exposes the [StudioRepository] registered in get_it to Riverpod.
@Riverpod(keepAlive: true)
StudioRepository studioRepository(Ref ref) => getIt<StudioRepository>();
