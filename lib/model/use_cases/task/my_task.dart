import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/entities/enum/observe_operate.dart';
import 'package:untitled_2/model/entities/todo/accounts/account.dart' as todo;
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firestore/collection_paging_repository.dart';
import 'package:untitled_2/model/repositories/firestore/document.dart';
import 'package:untitled_2/model/repositories/firestore/document_repository.dart';
import 'package:untitled_2/model/use_cases/auth/auth_state_controller.dart';
import 'package:untitled_2/model/use_cases/task/task_observer_provider.dart';
import 'package:untitled_2/utils/logger.dart';

final myTaskProvider = StateNotifierProvider<MyTask, List<Task>>((ref) {
  ref.watch(authStateControllerProvider);
  return MyTask(ref);
});

class MyTask extends StateNotifier<List<Task>> {
  MyTask(this._ref) : super(<Task>[]) {
    _taskDisposer = _ref.read(taskObserverProvider).fetch.listen((event) {
      if (event.operate == ObserveOperate.create) {
        state = [event.data, ...state];
      } else if (event.operate == ObserveOperate.update) {
        state = state
            .map((e) => e.taskId == event.data.taskId ? event.data : e)
            .toList();
      } else if (event.operate == ObserveOperate.delete) {
        state = state
            .where((element) => element.taskId != event.data.taskId)
            .toList();
      }
    });

    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return;
    }
    _collectionPagingRepository = CollectionPagingRepository<Task>(
      query: Document.collectionRef(todo.Account.taskCollectionPath(userId))
          .orderBy('createdAt', descending: true),
      limit: 5,
      decode: Task.fromJson,
    );
  }

  final Ref _ref;

  FirebaseAuthRepository get _firebaseAuthRepository =>
      _ref.read(firebaseAuthRepositoryProvider);

  DocumentRepository get _documentRepository =>
      _ref.read(documentRepositoryProvider);
  CollectionPagingRepository<Task>? _collectionPagingRepository;

  late StreamSubscription<TaskOperateState> _taskDisposer;

  @override
  void dispose() {
    super.dispose();
    _taskDisposer.cancel();
  }

  Future<List<Task>> fetch() async {
    final repository = _collectionPagingRepository;
    if (repository == null) {
      return [];
    }
    final data = await repository.fetch(fromCache: (caches) {
      state = caches.map((e) => e.entity).whereType<Task>().toList();
    });
    final results = data.map((e) => e.entity).whereType<Task>().toList();
    state = results;
    return results;
  }

  Future<List<Task>> fetchMore() async {
    final repository = _collectionPagingRepository;
    if (repository == null) {
      return [];
    }
    final results = await repository.fetchMore();
    final newList = state.toList()
      ..addAll(results.map((e) => e.entity).whereType<Task>().toList());
    state = newList;
    return newList;
  }

  Future<void> update({
    required String taskId,
    required String title,
    required String comment,
    required bool isDone,
  }) async {
    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return;
    }

    await _documentRepository.update(
      todo.Account.taskCollectionDocPath(userId, taskId),
      data: Task.toUpdate(
        title: title,
        comment: comment,
      ),
    );
    final newData =
        state.firstWhereOrNull((element) => element.taskId == taskId)?.copyWith(
              title: title,
              comment: comment,
              updatedAt: DateTime.now(),
            );
    if (newData != null) {
      state = state.map((e) => e.taskId == taskId ? newData : e).toList();
    }
  }

  Future<void> upIsDone({
    required String taskId,
    required bool isNotDone,
  }) async {
    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return;
    }

    await _documentRepository.update(
      todo.Account.taskCollectionDocPath(userId, taskId),
      data: Task.toUpIsDone(
        isNotDone: isNotDone,
      ),
    );

    final newData =
        state.firstWhereOrNull((element) => element.taskId == taskId)?.copyWith(
              isNotDone: isNotDone,
              updatedAt: DateTime.now(),
            );
    if (newData != null) {
      state = state.map((e) => e.taskId == taskId ? newData : e).toList();
    }
  }

  Future<void> delete(String taskId) async {
    final userId = _firebaseAuthRepository.loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return;
    }
    await _documentRepository
        .remove(todo.Account.taskCollectionDocPath(userId, taskId));
    state = state.where((element) => element.taskId != taskId).toList();
  }
}
