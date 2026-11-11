import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/di/injection.dart';
import 'auth_repository.dart';

part 'auth_repository_provider.g.dart';

/// Exposes the [AuthRepository] registered in get_it to Riverpod.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => getIt<AuthRepository>();
