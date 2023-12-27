import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_2/features/account/pages/account_page.dart';
import 'package:untitled_2/features/account/pages/edit_profile_page.dart';
import 'package:untitled_2/features/authentication/pages/sign_in_page.dart';
import 'package:untitled_2/features/authentication/pages/sign_up_page.dart';
import 'package:untitled_2/features/todo/entities/task/task.dart';
import 'package:untitled_2/features/todo/pages/add_todo_task_page.dart';
import 'package:untitled_2/features/todo/pages/edit_todo_task_page.dart';
import 'package:untitled_2/features/todo/pages/todo_page.dart';
import 'package:untitled_2/main.dart';

part 'router.g.dart';

@TypedStatefulShellRoute<MyStatefulShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<BranchSingUpData>(
      routes: [
        TypedGoRoute<SingUpRouteData>(
          path: '/sing_up',
        ),
      ],
    ),
    TypedStatefulShellBranch<BranchSingInData>(
      routes: [
        TypedGoRoute<SingInRouteData>(path: '/sing_in'),
      ],
    ),
    TypedStatefulShellBranch<BranchAccountData>(
      routes: [
        TypedGoRoute<AccountRouteData>(
          path: '/account',
          routes: [
            TypedGoRoute<EditProfileRouteData>(path: 'edit_profile'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<BranchTodoData>(
      routes: [
        TypedGoRoute<TodoRouteData>(
          path: '/todo',
          routes: [
            TypedGoRoute<AddTodoRouteData>(path: 'add_todo'),
            TypedGoRoute<EditTodoRouteData>(path: 'edit_todo'),
          ],
        ),
      ],
    ),
  ],
)
class MyStatefulShellRouteData extends StatefulShellRouteData {
  const MyStatefulShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MyWidget(navigationShell: navigationShell);
  }
}

class SingUpRouteData extends GoRouteData {
  const SingUpRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const SingUpPage();
}

class BranchSingUpData extends StatefulShellBranchData {
  const BranchSingUpData();
}

class BranchSingInData extends StatefulShellBranchData {
  const BranchSingInData();
}

class BranchAccountData extends StatefulShellBranchData {
  const BranchAccountData();
}

class BranchTodoData extends StatefulShellBranchData {
  const BranchTodoData();
}

class SingInRouteData extends GoRouteData {
  const SingInRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const SingInPage();
}

class AccountRouteData extends GoRouteData {
  const AccountRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const AccountPage();
}

class EditProfileRouteData extends GoRouteData {
  const EditProfileRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const EditProfilePage();
}

class TodoRouteData extends GoRouteData {
  const TodoRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const TodoPage();
}

class AddTodoRouteData extends GoRouteData {
  const AddTodoRouteData();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const AddTodoTaskPage();
}

class EditTodoRouteData extends GoRouteData {
  const EditTodoRouteData({required this.$extra});

  final Task $extra;

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      EditTodoTaskPage(data: $extra);
}
