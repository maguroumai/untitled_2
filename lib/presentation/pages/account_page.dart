import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/use_cases/my_account_controller.dart';
import 'package:untitled_2/presentation/pages/edit_profile_page.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(myAccountControllerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await ref
                    .read(myAccountControllerProvider.notifier)
                    .fetchProfile();
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
              },
              icon: const Icon(Icons.edit_note_sharp))
        ],
        title: const Text('アカウント'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${account.name}'),
              account.gender == Gender.woman
                  ? const Icon(
                      Icons.female,
                      size: 16,
                      color: Colors.pinkAccent,
                    )
                  : const Icon(
                      Icons.male,
                      size: 16,
                      color: Colors.blue,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
