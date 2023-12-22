import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/model/entities/todo/accounts/account.dart' as todo;
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firestore/document_repository.dart';
import 'package:untitled_2/model/use_cases/task/my_task.dart';
import 'package:untitled_2/model/use_cases/task/task_observer_provider.dart';
import 'package:untitled_2/utils/logger.dart';

part 'save_task.g.dart';

@riverpod
class SaveTask extends _$SaveTask {
  String? get _loggedInUserId =>
      ref.read(firebaseAuthRepositoryProvider).loggedInUserId;

  DocumentRepository get _documentRepository =>
      ref.read(documentRepositoryProvider);

  @override
  FutureOr<Task?> build({
    required String title,
    required String comment,
  }) async {
    final userId = _loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return null;
    }

    final docId = _documentRepository.docId;
    final now = DateTime.now();
    final task = Task(
      accountId: userId,
      taskId: docId,
      title: title,
      isNotDone: true,
      comment: comment,
      createdAt: now,
      updatedAt: now,
    );
    await _documentRepository.save(
      todo.Account.taskCollectionDocPath(userId, docId),
      data: task.toDoc(),
    );
    ref.watch(taskObserverProvider).create(task);
    ref.invalidate(myTaskControllerProvider);
    return task;
  }
}
