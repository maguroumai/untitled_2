/*
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/account/account.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firebase_auth/login_type.dart';
import 'package:untitled_2/model/repositories/firestore/document.dart';
import 'package:untitled_2/model/repositories/firestore/document_repository.dart';
import 'package:untitled_2/utils/logger.dart';
import 'package:untitled_2/utils/provider.dart';

final myAccountControllerProvider =
    StateNotifierProvider<MyAccountController, Account>((ref) {
  final authState = ref.watch(authStateProvider);
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
      name: name,
      gender: gender,
    );

    final batch = _documentRepository.batch
      ..update(Document.docRef(Account.docPath(userId)), data.toDoc());
    await batch.commit();
    state = data;
  }
}
*/
