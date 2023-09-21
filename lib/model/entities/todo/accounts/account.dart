import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:untitled_2/model/entities/todo/task/task.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  factory Account({
    String? accountId,
    String? todoId,
  }) = _Account;
  Account._();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  static String get collectionPath => 'todo/v1/accounts';
  static String docPath(String id) => '$collectionPath/$id';

  static String taskCollectionPath(String userId) =>
      Task.collectionPath(docPath(userId));
  static String taskCollectionDocPath(String userId, String taskId) =>
      Task.docPath(docPath(userId), taskId);
}
