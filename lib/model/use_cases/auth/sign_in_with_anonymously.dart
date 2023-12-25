import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';

/// 匿名認証
final signInWithAnonymously = Provider(SignInWithAnonymously.new);

class SignInWithAnonymously {
  SignInWithAnonymously(this._ref);
  final Ref _ref;

  Future<User?> call() async {
    final userCredential =
        await _ref.read(firebaseAuthRepositoryProvider).signInWithAnonymously();
    print(userCredential.user);
    return userCredential.user;
  }
}
