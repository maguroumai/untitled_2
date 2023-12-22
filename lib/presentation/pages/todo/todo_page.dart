import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/presentation/pages/todo/task_tab.dart';
import 'package:untitled_2/router/router.dart';

class TodoPage extends HookConsumerWidget {
  const TodoPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  const AddTodoRouteData().push(context);
                },
                icon: const Icon(Icons.add_circle_outline))
          ],
          title: const Text('TODO'),
        ),
        body: const Stack(
          children: [
            TaskTab(),
          ],
        ));
  }
}
