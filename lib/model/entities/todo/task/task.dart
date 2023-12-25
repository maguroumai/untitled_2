import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:untitled_2/model/entities/converters/date_time_timestamp_converter.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  factory Task({
    String? accountId,
    String? taskId,
    String? title,
    String? comment,
    bool? isNotDone,
    @DateTimeTimestampConverter() DateTime? createdAt,
    @DateTimeTimestampConverter() DateTime? updatedAt,
  }) = _Task;

  Task._();

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  static String get collectionName => 'taskList';
  static String collectionPath(String path) => '$path/$collectionName';

  static String docPath(String path, String id) =>
      '${collectionPath(path)}/$id';

  bool get isDone => isNotDone == null || isNotDone == false;

  static Map<String, dynamic> toUpdate({
    required String? title,
    required String? comment,
  }) {
    final value = <String, dynamic>{
      'title': title,
      'comment': comment,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return value;
  }

  static Map<String, dynamic> toUpIsDone({
    required bool isNotDone,
  }) {
    final value = <String, dynamic>{
      'isNotDone': isNotDone,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return value;
  }

  Map<String, dynamic> toDoc() {
    final value = <String, dynamic>{
      ...toJson(),
      'taskId': taskId,
      'title': title,
      'comment': comment,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (createdAt == null) {
      value['createdAt'] = FieldValue.serverTimestamp();
    }
    return value;
  }
}
