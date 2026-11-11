import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/auth_session_provider.dart';

part 'projects_view_model.g.dart';

/// ViewModel of the projects screen.
///
/// Project listing is not built yet; for now it only handles signing out.
@riverpod
class ProjectsViewModel extends _$ProjectsViewModel {
  @override
  void build() {}

  /// Signs out of this device; the router's auth guard then navigates to
  /// `/login`.
  Future<void> signOut() => ref.read(authSessionProvider).signOut();
}
