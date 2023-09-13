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

    // final genderKey = useState(GlobalKey<FormFieldState<String>>());
    final selectedGenderState = useState(Gender.none);
    // final isLoading = useState(false);

    final state = ref.watch(myAccountControllerProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.name != null) {
          nameKey.value.currentState?.didChange(state.name);
        }
      });
      return null;
    }, [state]);

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
              DropdownButton<Gender>(
                value: selectedGenderState.value,
                onChanged: (Gender? newValue) {
                  selectedGenderState.value = newValue ?? Gender.none;
                },
                items: Gender.values
                    .map<DropdownMenuItem<Gender>>((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.getLabel(context)),
                  );
                }).toList(),
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
                            gender: selectedGenderState.value,
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
