import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/custom_hooks/use_global_key.dart';
import 'package:untitled_2/core/extensions/string_extension.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/core/widgets/show_indicator.dart';
import 'package:untitled_2/features/authentication/use_cases/sign_up_with_email_and_password.dart';

class SingUpPage extends HookConsumerWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormFieldKey = useFormFieldStateKey();
    final passwordFormFieldKey = useFormFieldStateKey();
    final confirmPasswordFormFieldKey = useFormFieldStateKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('登録'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                key: emailFormFieldKey,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                validator: (value) => (value == null || value.isEmpty)
                    ? '正しいメールアドレスを入力してください'
                    : null,
              ),
              TextFormField(
                key: passwordFormFieldKey,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  hintText: '大文字小文字含む英数字8桁以上',
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'パスワード' : null,
                obscureText: true,
              ),
              TextFormField(
                key: confirmPasswordFormFieldKey,
                decoration: const InputDecoration(labelText: 'パスワード確認'),
                obscureText: true,
                validator: (value) {
                  final passwordText =
                      passwordFormFieldKey.currentState?.value?.trim();
                  if (value == null ||
                      !value.trim().isPassword ||
                      value != passwordText) {
                    return '正しいパスワードを入力してください';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: const Text('登録'),
                onPressed: () async {
                  final isValidEmail =
                      emailFormFieldKey.currentState?.validate() ?? false;
                  final isValidPassword =
                      passwordFormFieldKey.currentState?.validate() ?? false;
                  final isValidConfirmPassword =
                      confirmPasswordFormFieldKey.currentState?.validate() ??
                          false;
                  if (!isValidEmail ||
                      !isValidPassword ||
                      !isValidConfirmPassword) {
                    logger.info('Invalid input data');
                    return;
                  }

                  final email = emailFormFieldKey.currentState?.value;
                  final password = passwordFormFieldKey.currentState?.value;
                  if (email == null || password == null) {
                    return;
                  }

                  try {
                    showIndicator(context);

                    await ref.read(signUpWithEmailAndPasswordProvider)(
                      email: email,
                      password: password,
                    );
                    if (!context.mounted) return;
                    dismissIndicator(context);
                    await showOkAlertDialog(
                      context: context,
                      title: '新規登録しました',
                    );
                    if (!context.mounted) return;
                    Theme.of(context);
                  } on Exception catch (e) {
                    dismissIndicator(context);
                    unawaited(
                      showOkAlertDialog(
                        context: context,
                        title: 'エラー',
                        message: e.toString(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
