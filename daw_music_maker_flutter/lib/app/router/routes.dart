import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_durations.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/projects/presentation/views/inbox_view.dart';
import '../../features/projects/presentation/views/project_detail_view.dart';
import '../../features/projects/presentation/views/project_form_view.dart';
import '../../features/projects/presentation/views/projects_view.dart';
import '../../shared/widgets/feedback/not_found_view.dart';

part 'routes.g.dart';

/// Page with a short fade + lift transition used by every route.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppDurations.slow,
    reverseTransitionDuration: AppDurations.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// `/login` — email + password sign-in.
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  /// Creates the route.
  const LoginRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const LoginView());
}

/// `/register` — create an account (email → code → password).
@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData with $RegisterRoute {
  /// Creates the route.
  const RegisterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const RegisterView());
}

/// `/forgot-password` — reset a password (email → code → new password).
@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  /// Creates the route.
  const ForgotPasswordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const ForgotPasswordView());
}

/// Parses a UUID route parameter; null when malformed.
UuidValue? _parseId(String id) {
  try {
    return UuidValue.withValidation(id);
  } on FormatException {
    return null;
  }
}

/// `/projects` — the signed-in landing screen (lists), with nested
/// `new`, `:id` and `:id/edit` routes.
@TypedGoRoute<ProjectsRoute>(
  path: '/projects',
  routes: [
    TypedGoRoute<NewProjectRoute>(path: 'new'),
    TypedGoRoute<ProjectDetailRoute>(
      path: ':id',
      routes: [TypedGoRoute<EditProjectRoute>(path: 'edit')],
    ),
  ],
)
class ProjectsRoute extends GoRouteData with $ProjectsRoute {
  /// Creates the route.
  const ProjectsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const ProjectsView());
}

/// `/projects/new` — create a project.
class NewProjectRoute extends GoRouteData with $NewProjectRoute {
  /// Creates the route.
  const NewProjectRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const ProjectFormView());
}

/// `/projects/:id` — project detail. [id] must be a UUID.
class ProjectDetailRoute extends GoRouteData with $ProjectDetailRoute {
  /// Creates the route for the project [id].
  const ProjectDetailRoute({required this.id});

  /// Project id (UUID string).
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final projectId = _parseId(id);
    return _fadePage(
      state,
      projectId == null
          ? const NotFoundView()
          : ProjectDetailView(projectId: projectId),
    );
  }
}

/// `/projects/:id/edit` — edit a project. [id] must be a UUID.
class EditProjectRoute extends GoRouteData with $EditProjectRoute {
  /// Creates the route for the project [id].
  const EditProjectRoute({required this.id});

  /// Project id (UUID string).
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final projectId = _parseId(id);
    return _fadePage(
      state,
      projectId == null
          ? const NotFoundView()
          : ProjectFormView(projectId: projectId),
    );
  }
}

/// `/inbox` — invitations received and join requests sent.
@TypedGoRoute<InboxRoute>(path: '/inbox')
class InboxRoute extends GoRouteData with $InboxRoute {
  /// Creates the route.
  const InboxRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const InboxView());
}
