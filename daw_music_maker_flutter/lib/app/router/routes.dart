import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_durations.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/projects/presentation/views/projects_view.dart';

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

/// `/projects` — the signed-in landing screen.
@TypedGoRoute<ProjectsRoute>(path: '/projects')
class ProjectsRoute extends GoRouteData with $ProjectsRoute {
  /// Creates the route.
  const ProjectsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadePage(state, const ProjectsView());
}
