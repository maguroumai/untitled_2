import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/use_cases/task/save_task.dart';

class AddTodoTaskPage extends HookConsumerWidget {
  const AddTodoTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleKey = useState(GlobalKey<FormFieldState<String>>());
    final commentKey = useState(GlobalKey<FormFieldState<String>>());

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
                initialValue: titleKey.value.currentState?.value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'タイトル' : null,
                decoration: const InputDecoration(labelText: '今日やる事'),
                onChanged: (value) {},
              ),
              TextFormField(
                key: commentKey.value,
                initialValue: commentKey.value.currentState?.value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? '詳細' : null,
                decoration: const InputDecoration(labelText: 'コメント'),
                onChanged: (value) {},
              ),
              ElevatedButton(
                  child: const Text('登録'),
                  onPressed: () async {
                    try {
                      final title =
                          titleKey.value.currentState?.value?.trim() ?? '';
                      final comment =
                          commentKey.value.currentState?.value?.trim() ?? '';
                      ref.read(
                          saveTaskProvider(title: title, comment: comment));
                      if (context.mounted) {
                        await showOkAlertDialog(
                          context: context,
                          title: '登録しました',
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
