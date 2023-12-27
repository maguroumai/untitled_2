import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/router/router.dart';
import 'package:untitled_2/core/widgets/show_indicator.dart';
import 'package:untitled_2/core/widgets/thumbnail.dart';
import 'package:untitled_2/features/account/entities/gender.dart';
import 'package:untitled_2/features/account/use_cases/delete_my_account.dart';
import 'package:untitled_2/features/account/use_cases/fetch_my_account.dart';
import 'package:untitled_2/features/authentication/use_cases/fetch_email.dart';
import 'package:untitled_2/features/authentication/use_cases/sign_out.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(fetchMyAccountProvider).asData?.value;
    final currentEmail = ref.read(fetchEmailProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (!context.mounted) return;
                const EditProfileRouteData().push(context);
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
              const CircleThumbnail(),
              Text('ログイン情報：$currentEmail'),
              Text('${account?.name}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (account?.gender ?? Gender.none).getLabel(context),
                  ),
                  account?.gender == Gender.none
                      ? const SizedBox.shrink()
                      : Icon(
                          account?.gender == Gender.woman
                              ? Icons.female
                              : Icons.male,
                          size: 16,
                          color: account?.gender == Gender.woman
                              ? Colors.pinkAccent
                              : Colors.blue,
                        )
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
                        final userId = account?.accountId;
                        if (userId == null) {
                          return;
                        }
                        await ref.read(deleteMyAccountProvider).call(userId);

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
