// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:daw_music_maker/app/di/register_module.dart' as _i246;
import 'package:daw_music_maker/core/auth/auth_session.dart' as _i630;
import 'package:daw_music_maker/features/auth/data/auth_repository.dart'
    as _i64;
import 'package:daw_music_maker/features/auth/data/auth_repository_impl.dart'
    as _i290;
import 'package:daw_music_maker/features/projects/data/collaboration_repository.dart'
    as _i49;
import 'package:daw_music_maker/features/projects/data/collaboration_repository_impl.dart'
    as _i88;
import 'package:daw_music_maker/features/projects/data/project_repository.dart'
    as _i879;
import 'package:daw_music_maker/features/projects/data/project_repository_impl.dart'
    as _i337;
import 'package:daw_music_maker_client/daw_music_maker_client.dart' as _i440;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    as _i90;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i440.Client>(
      () => registerModule.client(),
      preResolve: true,
    );
    gh.lazySingleton<_i440.EndpointEmailIdp>(
      () => registerModule.emailIdp(gh<_i440.Client>()),
    );
    gh.lazySingleton<_i440.EndpointProject>(
      () => registerModule.projectEndpoint(gh<_i440.Client>()),
    );
    gh.lazySingleton<_i440.EndpointProjectCollaboration>(
      () => registerModule.projectCollaborationEndpoint(gh<_i440.Client>()),
    );
    gh.lazySingleton<_i90.FlutterAuthSessionManager>(
      () => registerModule.authSessionManager(gh<_i440.Client>()),
    );
    gh.lazySingleton<_i49.CollaborationRepository>(
      () => _i88.CollaborationRepositoryImpl(
        gh<_i440.EndpointProjectCollaboration>(),
      ),
    );
    gh.lazySingleton<_i879.ProjectRepository>(
      () => _i337.ProjectRepositoryImpl(gh<_i440.EndpointProject>()),
    );
    gh.lazySingleton<_i64.AuthRepository>(
      () => _i290.AuthRepositoryImpl(
        gh<_i440.EndpointEmailIdp>(),
        gh<_i90.FlutterAuthSessionManager>(),
      ),
    );
    gh.lazySingleton<_i630.AuthSession>(
      () => _i630.AuthSessionImpl(gh<_i90.FlutterAuthSessionManager>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i246.RegisterModule {}
