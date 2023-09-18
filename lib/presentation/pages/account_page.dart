import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/use_cases/auth/fetch_email.dart';
import 'package:untitled_2/model/use_cases/auth/sign_out.dart';
import 'package:untitled_2/model/use_cases/my_account_controller.dart';
import 'package:untitled_2/presentation/pages/edit_profile_page.dart';
import 'package:untitled_2/presentation/widgets/show_indicator.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(myAccountControllerProvider);
    final currentEmail = ref.read(fetchEmailProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
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
              Text('ログイン情報：$currentEmail'),
              Text('${account.name}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(account.gender.getLabel(context)),
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
              Center(
                child: TextButton(
                  onPressed: () async {
                    final result = await showOkCancelAlertDialog(
                      context: context,
                      title: 'ログアウトする',
                    );
                    if (result == OkCancelResult.ok) {
                      try {
                        if (!context.mounted) return;
                        showIndicator(context);
                        await ref.read(signOut)();
                        if (!context.mounted) return;
                        dismissIndicator(context);
                        Theme.of(context);
                      } on Exception catch (e) {
                        if (!context.mounted) return;
                        dismissIndicator(context);
                        unawaited(
                          showOkAlertDialog(
                            context: context,
                            title: 'エラー',
                            message: e.toString(),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('ログアウト'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final result = await showOkCancelAlertDialog(
                      context: context,
                      title: 'アカウント削除',
                    );
                    if (result == OkCancelResult.ok) {
                      try {
                        if (!context.mounted) return;
                        showIndicator(context);
                        final userId = account.accountId;
                        if (userId == null) {
                          return;
                        }
                        await ref
                            .read(myAccountControllerProvider.notifier)
                            .deleteAccount(userId);

                        if (!context.mounted) return;
                        dismissIndicator(context);
                        Theme.of(context);
                      } on Exception catch (e) {
                        if (!context.mounted) return;
                        dismissIndicator(context);
                        unawaited(
                          showOkAlertDialog(
                            context: context,
                            title: 'エラー',
                            message: e.toString(),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('アカウント削除'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
