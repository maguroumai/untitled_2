import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/todo/accounts/account.dart' as todo;
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firestore/document_repository.dart';
import 'package:untitled_2/model/use_cases/task/task_observer_provider.dart';
import 'package:untitled_2/utils/logger.dart';

final saveTask = Provider(SaveTask.new);

class SaveTask {
  SaveTask(this._ref);

  final Ref _ref;

  Future<Task?> call({
    required String title,
    required String comment,
  }) async {
    final firebaseAuthRepository = _ref.read(firebaseAuthRepositoryProvider);
    final userId = firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return null;
    }
    final documentRepository = _ref.read(documentRepositoryProvider);

    final docId = documentRepository.docId;
    final now = DateTime.now();
    final data = Task(
      accountId: userId,
      taskId: docId,
      title: title,
      isNotDone: true,
      comment: comment,
      createdAt: now,
      updatedAt: now,
    );

    await documentRepository.save(
      todo.Account.taskCollectionDocPath(userId, docId),
      data: data.toDoc(),
    );
    _ref.read(taskObserverProvider).create(data);

    return data;
  }
}
