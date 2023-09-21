import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/subjects.dart';
import 'package:untitled_2/model/entities/enum/observe_operate.dart';
import 'package:untitled_2/model/entities/todo/task/task.dart';

final taskObserverProvider = Provider((ref) {
  return TaskObserver();
});

@immutable
class TaskOperateState {
  const TaskOperateState(this.operate, this.data);
  final ObserveOperate operate;
  final Task data;
}

class TaskObserver {
  Stream<TaskOperateState> get fetch => _subject.stream;

  final PublishSubject<TaskOperateState> _subject = PublishSubject();

  void create(Task data) =>
      _subject.add(TaskOperateState(ObserveOperate.create, data));

  void update(Task data) =>
      _subject.add(TaskOperateState(ObserveOperate.update, data));

  void delete(Task data) =>
      _subject.add(TaskOperateState(ObserveOperate.delete, data));
}
