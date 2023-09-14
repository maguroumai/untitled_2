import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';

final fetchEmailProvider = Provider.autoDispose<String?>((ref) {
  return ref.read(firebaseAuthRepositoryProvider).authUser?.email;
});
