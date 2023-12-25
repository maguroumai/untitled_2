// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $myStatefulShellRouteData,
    ];

RouteBase get $myStatefulShellRouteData => StatefulShellRouteData.$route(
      factory: $MyStatefulShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/sing_up',
              factory: $SingUpRouteDataExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/sing_in',
              factory: $SingInRouteDataExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/account',
              factory: $AccountRouteDataExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit_profile',
                  factory: $EditProfileRouteDataExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/todo',
              factory: $TodoRouteDataExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'add_todo',
                  factory: $AddTodoRouteDataExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'edit_todo',
                  factory: $EditTodoRouteDataExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $MyStatefulShellRouteDataExtension on MyStatefulShellRouteData {
  static MyStatefulShellRouteData _fromState(GoRouterState state) =>
      const MyStatefulShellRouteData();
}

extension $SingUpRouteDataExtension on SingUpRouteData {
  static SingUpRouteData _fromState(GoRouterState state) =>
      const SingUpRouteData();

  String get location => GoRouteData.$location(
        '/sing_up',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SingInRouteDataExtension on SingInRouteData {
  static SingInRouteData _fromState(GoRouterState state) =>
      const SingInRouteData();

  String get location => GoRouteData.$location(
        '/sing_in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AccountRouteDataExtension on AccountRouteData {
  static AccountRouteData _fromState(GoRouterState state) =>
      const AccountRouteData();

  String get location => GoRouteData.$location(
        '/account',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditProfileRouteDataExtension on EditProfileRouteData {
  static EditProfileRouteData _fromState(GoRouterState state) =>
      const EditProfileRouteData();

  String get location => GoRouteData.$location(
        '/account/edit_profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TodoRouteDataExtension on TodoRouteData {
  static TodoRouteData _fromState(GoRouterState state) => const TodoRouteData();

  String get location => GoRouteData.$location(
        '/todo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddTodoRouteDataExtension on AddTodoRouteData {
  static AddTodoRouteData _fromState(GoRouterState state) =>
      const AddTodoRouteData();

  String get location => GoRouteData.$location(
        '/todo/add_todo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditTodoRouteDataExtension on EditTodoRouteData {
  static EditTodoRouteData _fromState(GoRouterState state) => EditTodoRouteData(
        $extra: state.extra as Task,
      );

  String get location => GoRouteData.$location(
        '/todo/edit_todo',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
