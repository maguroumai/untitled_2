import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/use_cases/task/my_task.dart';
import 'package:untitled_2/model/use_cases/task/task_observer_provider.dart';
import 'package:untitled_2/presentation/widgets/show_indicator.dart';

class EditTodoTaskPage extends HookConsumerWidget {
  const EditTodoTaskPage({required this.data, Key? key}) : super(key: key);

  final Task data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleKey = useState(GlobalKey<FormFieldState<String>>());
    final commentKey = useState(GlobalKey<FormFieldState<String>>());
    final myTaskController = ref.watch(myTaskProvider.notifier);

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
                key: titleKey.value,
                initialValue: data.title,
                decoration: const InputDecoration(labelText: '今日やる事'),
                onChanged: (value) {},
              ),
              TextFormField(
                key: commentKey.value,
                initialValue: data.comment,
                decoration: const InputDecoration(labelText: 'コメント'),
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                  ),
                  ElevatedButton(
                      child: const Text('削除'),
                      onPressed: () async {
                        try {
                          final taskId = data.taskId;
                          if (taskId == null) {
                            return;
                          }
                          await myTaskController.delete(taskId);
                          ref.read(taskObserverProvider).delete(data);
                          if (!context.mounted) return;
                          dismissIndicator(context);
                          await showOkAlertDialog(
                            context: context,
                            title: '更新しました',
                          );
                          if (!context.mounted) return;
                          Theme.of(context);
                        } catch (e) {
                          await showOkAlertDialog(
                            context: context,
                            title: 'エラー',
                            message: e.toString(),
                          );
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: ElevatedButton(
                        child: const Text('更新'),
                        onPressed: () async {
                          try {
                            final taskId = data.taskId;
                            final isDone = data.isDone;
                            if (taskId == null) {
                              return;
                            }
                            final title =
                                titleKey.value.currentState?.value?.trim() ??
                                    '';
                            final comment =
                                commentKey.value.currentState?.value?.trim() ??
                                    '';
                            await myTaskController.update(
                                taskId: taskId,
                                title: title,
                                comment: comment,
                                isDone: isDone);
                            ref.read(taskObserverProvider).update(data.copyWith(
                                  title: title,
                                  comment: comment,
                                  updatedAt: DateTime.now(),
                                ));
                            if (!context.mounted) return;
                            dismissIndicator(context);
                            await showOkAlertDialog(
                              context: context,
                              title: '更新しました',
                            );
                            if (!context.mounted) return;
                            Theme.of(context);
                          } catch (e) {
                            await showOkAlertDialog(
                              context: context,
                              title: 'エラー',
                              message: e.toString(),
                            );
                          }
                        }),
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
