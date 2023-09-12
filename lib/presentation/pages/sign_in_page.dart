import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:untitled_2/model/use_cases/auth/sign_in_with_account.dart';
import 'package:untitled_2/model/use_cases/auth/sign_in_with_anonymously.dart';
import 'package:untitled_2/model/use_cases/auth/sign_in_with_email_and_password.dart';
import 'package:untitled_2/presentation/custom_hooks/use_global_key.dart';
import 'package:untitled_2/presentation/widgets/show_indicator.dart';
import 'package:untitled_2/utils/logger.dart';

import '../../model/repositories/firebase_auth/login_type.dart';

class SingInPage extends HookConsumerWidget {
  const SingInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormFieldKey = useFormFieldStateKey();
    final passwordFormFieldKey = useFormFieldStateKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
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
              ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  final isValidEmail =
                      emailFormFieldKey.currentState?.validate() ?? false;
                  final isValidPassword =
                      passwordFormFieldKey.currentState?.validate() ?? false;
                  false;
                  if (!isValidEmail || !isValidPassword) {
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

                    await ref.read(signInWithEmailAndPasswordProvider)(
                      email: email,
                      password: password,
                    );
                    if (!context.mounted) return;
                    dismissIndicator(context);
                    await showOkAlertDialog(
                      context: context,
                      title: 'ログインしました',
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
              ElevatedButton(
                child: const Text('匿名でログインする'),
                onPressed: () async {
                  try {
                    await ref.read(signInWithAnonymously)();
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SignInButton(
                Buttons.google,
                onPressed: () async {
                  try {
                    await ref.read(signInWithAccount)(LoginType.google);
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
