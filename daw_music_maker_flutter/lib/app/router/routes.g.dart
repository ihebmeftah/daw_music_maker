// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $registerRoute,
  $forgotPasswordRoute,
  $projectsRoute,
  $inboxRoute,
];

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  hasOverriddenOnExit: false,
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $projectsRoute => GoRouteData.$route(
  path: '/projects',
  hasOverriddenOnExit: false,
  factory: $ProjectsRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'form',
      hasOverriddenOnExit: false,
      factory: $ProjectFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: ':id',
      hasOverriddenOnExit: false,
      factory: $ProjectDetailRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'studio',
          hasOverriddenOnExit: false,
          factory: $StudioRoute._fromState,
        ),
      ],
    ),
  ],
);

mixin $ProjectsRoute on GoRouteData {
  static ProjectsRoute _fromState(GoRouterState state) => const ProjectsRoute();

  @override
  String get location => GoRouteData.$location('/projects');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProjectFormRoute on GoRouteData {
  static ProjectFormRoute _fromState(GoRouterState state) =>
      ProjectFormRoute(id: state.uri.queryParameters['id']);

  ProjectFormRoute get _self => this as ProjectFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/projects/form',
    queryParams: {if (_self.id != null) 'id': _self.id},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProjectDetailRoute on GoRouteData {
  static ProjectDetailRoute _fromState(GoRouterState state) =>
      ProjectDetailRoute(id: state.pathParameters['id']!);

  ProjectDetailRoute get _self => this as ProjectDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/projects/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StudioRoute on GoRouteData {
  static StudioRoute _fromState(GoRouterState state) =>
      StudioRoute(id: state.pathParameters['id']!);

  StudioRoute get _self => this as StudioRoute;

  @override
  String get location => GoRouteData.$location(
    '/projects/${Uri.encodeComponent(_self.id)}/studio',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $inboxRoute => GoRouteData.$route(
  path: '/inbox',
  hasOverriddenOnExit: false,
  factory: $InboxRoute._fromState,
);

mixin $InboxRoute on GoRouteData {
  static InboxRoute _fromState(GoRouterState state) => const InboxRoute();

  @override
  String get location => GoRouteData.$location('/inbox');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
