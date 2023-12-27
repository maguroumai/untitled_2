import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/features/account/entities/account.dart';
import 'package:untitled_2/features/account/entities/gender.dart';
import 'package:untitled_2/features/account/use_cases/fetch_my_account.dart';

part 'save_my_account.g.dart';

@riverpod
SaveMyAccount saveMyAccount(SaveMyAccountRef ref) {
  return SaveMyAccount(ref);
}

class SaveMyAccount {
  SaveMyAccount(this._ref);
  final SaveMyAccountRef _ref;

  Future<void> call({
    required String name,
    required Gender gender,
  }) async {
    final userId = _ref.read(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      logger.info('userId is null or anonymously');
      return;
    }

    final profile = _ref.read(fetchMyAccountProvider).asData?.value;
    final newProfile = (profile ?? Account(accountId: userId)).copyWith(
      accountId: userId,
      name: name,
      gender: gender,
    );
    await _ref.read(documentRepositoryProvider).save(
          Account.docPath(userId),
          data: newProfile.toJson(),
        );
  }
}
