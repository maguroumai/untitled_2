import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firebase_auth/login_type.dart';
import 'package:untitled_2/core/repositories/firestore/document.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/features/account/entities/account.dart';

final signInWithAccount = Provider(SignInWithAccount.new);

class SignInWithAccount {
  SignInWithAccount(this._ref);
  final Ref _ref;

  Future<Document<Account>?> call(LoginType loginType) async {
    final firebaseAuthRepository = _ref.read(firebaseAuthRepositoryProvider);
    final documentRepository = _ref.read(documentRepositoryProvider);

    try {
      /// ソーシャル認証
      final providerCredential = await Future(() async {
        if (loginType == LoginType.google) {
          return firebaseAuthRepository.credentialOfGoogle;
        } else if (loginType == LoginType.email) {
          Provider.autoDispose<String?>((ref) {
            return ref.read(firebaseAuthRepositoryProvider).authUser?.email;
          });
        }
        return null;
      });

      if (providerCredential == null) {
        return null;
      }

      /// Firebaseへ認証
      final userCredential = await Future(() async {
        final providerId = providerCredential.userId;
        final credential = providerCredential.credential;
        logger.info('providerId $providerId');

        /// 匿名認証でログインしている場合は削除する
        final oldUser = firebaseAuthRepository.authUser;
        if (firebaseAuthRepository.loginType == LoginType.anonymously &&
            oldUser != null) {
          await firebaseAuthRepository.userDelete(oldUser);
        }
        return firebaseAuthRepository.signInWithAuthCredential(credential);
      });

      final userId = userCredential.user?.uid;
      if (userId == null) {
        return null;
      }

      /// ユーザー作成
      await Future(() async {
        final account = await documentRepository.fetch<Account>(
          Account.docPath(userId),
          decode: Account.fromJson,
        );
        if (!account.exists) {
          final newAccount = Account(accountId: userId);

          final batch = documentRepository.batch
            ..set(Document.docRef(Account.docPath(userId)), newAccount.toDoc(),
                SetOptions(merge: true));
          await batch.commit();
          account.copyWith(newAccount);
        }
        return account;
      });
    } on Exception catch (e) {
      logger.shout(e);
      rethrow;
    }
    return null;
  }
}
