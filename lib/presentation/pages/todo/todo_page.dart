import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/presentation/pages/todo/add_todo_task_page.dart';
import 'package:untitled_2/presentation/pages/todo/task_tab.dart';

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
                onPressed: () async {
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTodoTaskPage()),
                  );
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
