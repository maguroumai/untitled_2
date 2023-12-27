import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/core/use_cases/authentication/auth_state_controller.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/features/account/entities/account.dart';

part 'fetch_my_account.g.dart';

@riverpod
class FetchMyAccount extends _$FetchMyAccount {
  @override
  Stream<Account?> build() {
    final authState = ref.watch(authStateControllerProvider);
    if (authState == AuthState.noSignIn) {
      return Stream.value(null);
    }
    final userId = ref.watch(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      return Stream.value(null);
    }
    logger.info('userId: $userId');
    return ref
        .watch(documentRepositoryProvider)
        .snapshots(Account.docPath(userId))
        .map((event) {
      final data = event.data();
      return data != null ? Account.fromJson(data) : null;
    });
  }
}
