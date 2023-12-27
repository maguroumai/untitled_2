import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/exceptions/app_exception.dart';
import 'package:untitled_2/core/repositories/firebase_auth/auth_error_code.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/use_cases/authentication/auth_state_controller.dart';
import 'package:untitled_2/core/utils/logger.dart';

final signUpWithEmailAndPasswordProvider =
    Provider(SignUpWithEmailAndPassword.new);

class SignUpWithEmailAndPassword {
  SignUpWithEmailAndPassword(this._ref);

  final Ref _ref;

  Future<void> call({
    required email,
    required password,
  }) async {
    try {
      final repository = _ref.read(firebaseAuthRepositoryProvider);
      final authStateController =
          _ref.read(authStateControllerProvider.notifier);
      await repository.createUserWithEmailAndPassword(email, password);

      authStateController.update(AuthState.signIn);

      logger.info('Emailサインアップに成功しました');
    } on FirebaseAuthException catch (e) {
      logger.shout(e);

      if (e.code == AuthErrorCode.invalidEmail.value ||
          e.code == AuthErrorCode.wrongPassword.value ||
          e.code == AuthErrorCode.userDisabled.value ||
          e.code == AuthErrorCode.userNotFound.value) {
        throw AppException(title: 'メールアドレスもしくはパスワードが正しくありません');
      } else {
        throw AppException(title: '不明なエラーです ${e.message}');
      }
    }
  }
}
