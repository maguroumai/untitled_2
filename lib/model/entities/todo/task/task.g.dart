// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      accountId: json['accountId'] as String?,
      taskId: json['taskId'] as String?,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      isNotDone: json['isNotDone'] as bool?,
      createdAt: const DateTimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp?),
      updatedAt: const DateTimeTimestampConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'taskId': instance.taskId,
      'title': instance.title,
      'comment': instance.comment,
      'isNotDone': instance.isNotDone,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
