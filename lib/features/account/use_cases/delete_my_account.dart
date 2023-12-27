import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/features/account/entities/account.dart';

part 'delete_my_account.g.dart';

@riverpod
DeleteMyAccount deleteMyAccount(DeleteMyAccountRef ref) {
  return DeleteMyAccount(ref);
}

class DeleteMyAccount {
  DeleteMyAccount(this._ref);
  final DeleteMyAccountRef _ref;

  Future<void> call(String userId) async {
    final userId = _ref.read(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      return;
    }

    await _ref.read(documentRepositoryProvider).remove(
          Account.docPath(userId),
        );
    await _ref.read(firebaseAuthRepositoryProvider).authUser?.delete();
  }
}
