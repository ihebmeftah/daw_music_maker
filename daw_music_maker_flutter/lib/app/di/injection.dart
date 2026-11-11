import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator for infrastructure (client, repositories).
///
/// Only read it from Riverpod bridge providers — never from widgets or
/// ViewModels.
final GetIt getIt = GetIt.instance;

/// Registers all `@injectable` dependencies. Awaited in `main` because the
/// Serverpod client is pre-resolved (server URL + stored session).
@InjectableInit()
Future<void> configureDependencies() => getIt.init();
