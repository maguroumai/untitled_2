import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/core/repositories/firestore/collection_paging_repository.dart';
import 'package:untitled_2/core/repositories/firestore/document.dart';
import 'package:untitled_2/core/repositories/firestore/document_repository.dart';
import 'package:untitled_2/core/use_cases/authentication/auth_state_controller.dart';
import 'package:untitled_2/core/utils/logger.dart';
import 'package:untitled_2/features/todo/entities/accounts/account.dart'
    as todo;
import 'package:untitled_2/features/todo/entities/task/task.dart';
import 'package:untitled_2/features/todo/use_cases/task/task_observer_provider.dart';

part 'task_controller.g.dart';

@riverpod
CollectionPagingRepository<Task> collectionPagingRepository(
  CollectionPagingRepositoryRef ref,
  CollectionParam<Task> query,
) {
  return CollectionPagingRepository<Task>(
    query: query.query,
    limit: query.limit,
    decode: query.decode,
  );
}

@riverpod
class TaskController extends _$TaskController {
  static int get defaultLimit => 5;

  String? get _loggedInUserId =>
      ref.read(firebaseAuthRepositoryProvider).loggedInUserId;

  DocumentRepository get _documentRepository =>
      ref.read(documentRepositoryProvider);

  CollectionPagingRepository<Task>? _collectionPagingRepository;

  @override
  FutureOr<List<Task>> build() async {
    ref.watch(authStateControllerProvider);

    final userId = _loggedInUserId;
    if (userId == null) {
      return [];
    }

    final repository = ref.watch(
      collectionPagingRepositoryProvider(
        CollectionParam<Task>(
          query: Document.collectionRef(todo.Account.taskCollectionPath(userId))
              .orderBy('createdAt', descending: true),
          limit: defaultLimit,
          decode: Task.fromJson,
        ),
      ),
    );
    _collectionPagingRepository = repository;

    final data = await repository.fetch(fromCache: (cache) {
      state = AsyncData(
        cache.map((e) => e.entity).whereType<Task>().toList(),
      );
    });
    return data.map((e) => e.entity).whereType<Task>().toList();
  }

  Future<void> fetchMore() async {
    final repository = _collectionPagingRepository;
    if (repository == null) {
      return;
    }

    final data = await repository.fetchMore();
    final previousState = await future;
    if (data.isNotEmpty) {
      state = AsyncData([
        ...previousState,
        ...data.map((e) => e.entity).whereType<Task>().toList(),
      ]);
    }
  }

  Future<void> onSave({required String title, required String comment}) async {
    final userId = _loggedInUserId;
    if (userId == null) {
      logger.shout('userId is null');
      return;
    }

    final docId = _documentRepository.docId;
    final now = DateTime.now();
    final value = await future;
    final data = Task(
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
      data: data.toDoc(),
    );
    ref.watch(taskObserverProvider).create(data);
    state = AsyncData(
      [
        data,
        ...value,
      ],
    );
  }

  Future<void> onUpdate(Task task) async {
    final userId = _loggedInUserId;
    final docId = task.taskId;
    if (userId == null || docId == null) {
      return;
    }
    final value = await future;
    final data = task.copyWith(updatedAt: DateTime.now());
    await ref.read(documentRepositoryProvider).update(
          todo.Account.taskCollectionDocPath(userId, docId),
          data: data.toUpdateDoc,
        );
    state = AsyncData(
      value
          .map(
            (e) => e.taskId == task.taskId ? task : e,
          )
          .toList(),
    );
  }

  Future<void> onIsDone(Task task) async {
    final userId = _loggedInUserId;
    final docId = task.taskId;
    if (userId == null || docId == null) {
      return;
    }

    final data = task.copyWith(
      taskId: task.taskId,
      isNotDone: task.isNotDone,
    );
    await ref.read(documentRepositoryProvider).update(
          todo.Account.taskCollectionDocPath(userId, docId),
          data: Task.toUpIsDone(
            isNotDone: data.isNotDone,
          ),
        );
    final value = await future;
    final newData =
        value.firstWhereOrNull((e) => e.taskId == data.taskId)?.copyWith(
              isNotDone: data.isNotDone,
              updatedAt: DateTime.now(),
            );
    if (newData != null) {
      state = AsyncData(
        value.map((e) => e.taskId == data.taskId ? newData : e).toList(),
      );
    }
  }

  Future<void> onRemove(String taskId) async {
    final userId = _loggedInUserId;

    if (userId == null) {
      return;
    }
    final value = await future;
    await ref
        .read(documentRepositoryProvider)
        .remove(todo.Account.taskCollectionDocPath(userId, taskId));
    state = AsyncData(
      value
          .where(
            (e) => e.taskId != taskId,
          )
          .toList(),
    );
  }
}
