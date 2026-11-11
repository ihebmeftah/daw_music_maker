import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/di/injection.dart';
import 'auth_session.dart';

part 'auth_session_provider.g.dart';

/// Exposes the [AuthSession] registered in get_it to Riverpod.
@Riverpod(keepAlive: true)
AuthSession authSession(Ref ref) => getIt<AuthSession>();
