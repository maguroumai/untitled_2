import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/use_cases/authentication/auth_state_controller.dart';

final signOut = Provider(SignOut.new);

class SignOut {
  SignOut(this._ref);
  final Ref _ref;

  Future<void> call() async {
    await _ref.read(firebaseAuthRepositoryProvider).signOut();
    _ref.read(authStateControllerProvider.notifier).update(AuthState.noSignIn);
  }
}
