/*
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';

class NextPage extends HookConsumerWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(firebaseAuthRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインしました'),
      ),
      body: Center(
          child: Text(
        '/${authRepository.authUser}',
      )),
    );
  }
}
*/
