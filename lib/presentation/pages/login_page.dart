import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firebase_auth/login_type.dart';
import 'package:untitled_2/model/use_cases/auth/sign_up_with_email_and_password.dart';
import 'package:untitled_2/model/use_cases/login_account.dart';
import 'package:untitled_2/presentation/custom_hooks/use_global_key.dart';
import 'package:untitled_2/presentation/pages/next_page.dart';
import 'package:untitled_2/utils/provider.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final emailFormFieldKey = useFormFieldStateKey();
    final passwordFormFieldKey = useFormFieldStateKey();
    final confirmPasswordFormFieldKey = useFormFieldStateKey();


    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
            key: emailFormFieldKey,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
    validator: (value) =>
    (value == null || value.isEmpty)
    ? '正しいメールアドレスを入力してください'
        : null,

                onTap: () {
              emailFormFieldKey.currentState?.didChange('');

    },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {},
              ),
              ElevatedButton(
                  child: const Text('登録'),
                  onPressed: () async {
    final isValidEmail =
    emailFormFieldKey.currentState?.validate() ?? false;
    final isValidPassword =
    passwordFormFieldKey.currentState?.validate() ?? false;
    final isValidConfirmPassword =
    confirmPasswordFormFieldKey.currentState?.validate() ?? false;
    if (!isValidEmail ||
    !isValidPassword ||
    !isValidConfirmPassword) {
    logger.info('invalid input data');
    return;
    }
    final email = emailFormFieldKey.currentState?.value;
    final password = passwordFormFieldKey.currentState?.value;
    if (email == null || password == null) {
    return;
    }try {
    showIndicator(context);
    await ref.read(signUpWithEmailAndPasswordProvider)(
    email: email,
    password: password,
    );
    dismissIndicator(context);
    await showOkAlertDialog(
    context: context,
    title: '新規登録しました',
    );
    context.pop();
    } on Exception catch (e) {
    dismissIndicator(context);
    unawaited(
    showOkAlertDialog(
    context: context,
    title: 'エラー',
    message: e.errorMessage,
    ),
    );
    }
    },),
          ]
                      )),
                    );
                  }),
              // 4行目 ログインボタン
/*ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final User? user = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _email, password: _password))
                        .user;
                    if (user != null)
                      print("ログインしました　${user.email} , ${user.uid}");
                  } catch (e) {
                    print(e);
                  }
                },
              ),*/ /*

              Container(
                width: 200,
                height: 30,
                child: SignInButton(Buttons.google, onPressed: () async {
                  final account =
                      await ref.read(loginAccount)(LoginType.google);
                  if (account != null) {
                    await Navigator.push(
                      context,
                      (MaterialPageRoute(
                        builder: (context) => const NextPage(),
                      )),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
