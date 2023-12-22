import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled_2/model/entities/todo/accounts/account.dart' as todo;
import 'package:untitled_2/model/entities/todo/task/task.dart';
import 'package:untitled_2/model/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:untitled_2/model/repositories/firestore/collection_paging_repository.dart';
import 'package:untitled_2/model/repositories/firestore/document.dart';
import 'package:untitled_2/model/repositories/firestore/document_repository.dart';
import 'package:untitled_2/model/use_cases/auth/auth_state_controller.dart';

part 'my_task.g.dart';

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
class MyTaskController extends _$MyTaskController {
  static int get defaultLimit => 5;

  String? get _loggedInUserId =>
      ref.read(firebaseAuthRepositoryProvider).loggedInUserId;

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
          value.map((e) => e.taskId == data.taskId ? newData : e).toList());
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
