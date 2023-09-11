import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/use_cases/my_account_controller.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameKey = useState(GlobalKey<FormFieldState<String>>());

    final genderKey = useState(GlobalKey<FormFieldState<String>>());
    final gender = useState(Gender.none);
    final isLoading = useState(false);

    final state = ref.watch(myAccountControllerProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.name != null) {
          nameKey.value.currentState?.didChange(state.name);
        }
        final _gender = state.gender;
        if (_gender != null) {
          gender.value = _gender;
          genderKey.value.currentState?.didChange(_gender.getLabel(context));
        }
      });
      return null;
    }, [state]);

    return Scaffold(
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
              DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: Gender.none,
                    child: Text('/${Gender.none}'),
                  ),
                  DropdownMenuItem(
                      value: Gender.man, child: Text('/${Gender.man}')),
                  DropdownMenuItem(
                      value: Gender.woman, child: Text('/${Gender.woman}')),
                ],
                onChanged: (Gender? value) {},
              ),
              ElevatedButton(
                  child: const Text('更新'),
                  onPressed: () async {
                    if (isLoading.value) {
                      return;
                    }
                    isLoading.value = true;
                    try {
                      final name =
                          nameKey.value.currentState?.value?.trim() ?? '';
                      await ref
                          .read(myAccountControllerProvider.notifier)
                          .saveProfile(
                            name: name.isNotEmpty ? name : '名無し',
                            gender: gender.value,
                          );
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
