import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/use_cases/task/my_task.dart';

class TaskItemTile extends HookConsumerWidget {
  const TaskItemTile(
    this.data, {
    required this.onTap,
    super.key,
  });

  final Task data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialTapGesture(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              data.comment ?? '',
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: !(data.isNotDone ?? true),
                        onChanged: (value) async {
                          if (value == null) {
                            return;
                          }
                          final taskId = data.taskId;
                          if (taskId == null) {
                            return;
                          }
                          print(value);
                          await ref
                              .watch(myTaskProvider.notifier)
                              .upIsDone(taskId: taskId, isNotDone: !value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
