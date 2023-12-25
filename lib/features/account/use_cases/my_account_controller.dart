import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firebase_auth/login_type.dart';
import 'package:untitled_2/core/repositories/firestore/document.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/core/use_cases/authentication/auth_state_controller.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/features/account/entities/account.dart';
import 'package:untitled_2/features/account/entities/gender.dart';

final myAccountControllerProvider =
    StateNotifierProvider<MyAccountController, Account>((ref) {
  final authState = ref.watch(authStateControllerProvider).isSignIn;
  logger.info(authState);
  return MyAccountController(ref);
});

class MyAccountController extends StateNotifier<Account> {
  MyAccountController(
    this._ref,
  ) : super(Account()) {
    Future(() async {
      await fetchProfile();
    });
  }

  final Ref _ref;

  FirebaseAuthRepository get _firebaseAuthRepository =>
      _ref.read(firebaseAuthRepositoryProvider);

  DocumentRepository get _documentRepository =>
      _ref.read(documentRepositoryProvider);

  Future<void> fetchProfile() async {
    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null ||
        _firebaseAuthRepository.loginType == LoginType.anonymously) {
      logger.info('userId is null or anonymously');
      return;
    }
    final account = await _documentRepository
        .fetch<Account>(Account.docPath(userId), decode: Account.fromJson);

    if (account.entity != null) {
      state = account.entity!;
    }
  }

  Future<void> saveProfile({
    required String name,
    required Gender gender,
  }) async {
    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.info('userId is null or anonymously');
      return;
    }
    final data = state.copyWith(
      accountId: userId,
      name: name,
      gender: gender,
    );

    final batch = _documentRepository.batch
      ..set(Document.docRef(Account.docPath(userId)), data.toDoc(),
          SetOptions(merge: true))
      ..update(Document.docRef(Account.docPath(userId)), data.toDoc());
    await batch.commit();

    state = data;
  }

  Future<void> deleteAccount(String userId) async {
    final userId = _ref.read(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      return;
    }
    await _documentRepository.remove(Account.docPath(userId));
    await _firebaseAuthRepository.authUser?.delete();

    state = Account();
  }

  /*Future<void> removeUser() async {
    final userId = _ref.read(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      return;
    }
    await _firebaseAuthRepository.authUser?.delete();
  }

  Future<void> deleteAccount(String userId) async {
    final userId = _ref.read(firebaseAuthRepositoryProvider).loggedInUserId;
    if (userId == null) {
      return;
    }
    await _documentRepository.remove(Account.docPath(userId));
  }*/
}
