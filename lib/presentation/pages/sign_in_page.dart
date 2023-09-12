import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:untitled_2/model/use_cases/auth/sign_in_with_account.dart';
import 'package:untitled_2/model/use_cases/auth/sign_in_with_anonymously.dart';

import '../../model/repositories/firebase_auth/login_type.dart';

class SingInPage extends HookConsumerWidget {
  const SingInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
