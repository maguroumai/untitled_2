import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/features/todo/entities/task/task.dart';
import 'package:untitled_2/features/todo/use_cases/task/task_controller.dart';
import 'package:untitled_2/features/todo/use_cases/task/task_observer_provider.dart';

class EditTodoTaskPage extends HookConsumerWidget {
  const EditTodoTaskPage({required this.data, Key? key}) : super(key: key);

  final Task data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: data.title);
    final commentController = useTextEditingController(text: data.comment);
    final controller = ref.watch(taskControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('今日やる事'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '今日やる事'),
                onChanged: (value) {},
              ),
              TextFormField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'コメント'),
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('削除'),
                    onPressed: () async {
                      try {
                        final taskId = data.taskId;
                        if (taskId == null) {
                          return;
                        }
                        await controller.onRemove(taskId);
                        ref.read(taskObserverProvider).delete(data);
                        if (context.mounted) {
                          await showOkAlertDialog(
                            context: context,
                            title: '削除しました',
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          await showOkAlertDialog(
                            context: context,
                            title: 'エラー',
                            message: e.toString(),
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    child: const Text('更新'),
                    onPressed: () async {
                      try {
                        final taskId = data.taskId;
                        if (taskId == null) {
                          return;
                        }
                        final title = titleController.text.trim();
                        final comment = commentController.text.trim();
                        await controller.onUpdate(
                          data.copyWith(title: title, comment: comment),
                        );

                        ref.read(taskObserverProvider).update(
                              data.copyWith(
                                title: title,
                                comment: comment,
                                updatedAt: DateTime.now(),
                              ),
                            );

                        if (context.mounted) {
                          await showOkAlertDialog(
                            context: context,
                            title: '更新しました',
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          await showOkAlertDialog(
                            context: context,
                            title: 'エラー',
                            message: e.toString(),
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
