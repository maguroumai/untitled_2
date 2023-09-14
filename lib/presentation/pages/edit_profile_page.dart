import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/use_cases/my_account_controller.dart';
import 'package:untitled_2/presentation/widgets/show_indicator.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameKey = useState(GlobalKey<FormFieldState<String>>());

    final genderKey = useState(GlobalKey<FormFieldState<String>>());
    final gender = useState(Gender.none);
    // final isLoading = useState(false);

    final state = ref.watch(myAccountControllerProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.name != null) {
          nameKey.value.currentState?.didChange(state.name);
        }
        /*final _gender = state.gender;
        gender.value = _gender;
        genderKey.value.currentState?.didChange(_gender.getLabel(context));*/
      });
      return null;
    }, [state]);

    final genderList = Gender.values.map((e) => e.getLabel(context)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                key: nameKey.value,
                initialValue: nameKey.value.currentState?.value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? '名前を入力してください' : null,
                decoration: const InputDecoration(labelText: 'ユーザー名'),
                onChanged: (value) {},
              ),
              DropdownButton<String>(
                value: gender.value.getLabel(context),
                items: genderList.map((String label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  final data = newValue ?? '';
                  gender.value = data.getToGenderWithLabel(context);
                  genderKey.value.currentState?.didChange(data);
                },
              ),
              ElevatedButton(
                  child: const Text('更新'),
                  onPressed: () async {
                    try {
                      final name =
                          nameKey.value.currentState?.value?.trim() ?? '';
                      await ref
                          .read(myAccountControllerProvider.notifier)
                          .saveProfile(
                            name: name.isNotEmpty ? name : '名無し',
                            gender: gender.value,
                          );
                      if (!context.mounted) return;
                      dismissIndicator(context);
                      await showOkAlertDialog(
                        context: context,
                        title: 'プロフィールを更新しました',
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
            ],
          ),
        ),
      ),
    );
  }
}
