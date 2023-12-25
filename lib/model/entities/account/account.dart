import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:untitled_2/model/entities/converters/date_time_timestamp_converter.dart';
import 'package:untitled_2/model/entities/enum/gender.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  factory Account({
    String? accountId,
    String? name,
    @GenderConverter() @Default(Gender.none) Gender gender,
    @DateTimeTimestampConverter() DateTime? createdAt,
    @DateTimeTimestampConverter() DateTime? updatedAt,
  }) = _Account;

  Account._();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  static String get collectionPath => 'users/v1/account';

  static String docPath(String id) => '$collectionPath/$id';

  static String usersDocPath(String accountId) =>
      Account.docPath(docPath(accountId));

  Map<String, dynamic> toDoc() {
    final value = <String, dynamic>{
      'accountId': accountId,
      'name': name,
      'gender': gender.name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (createdAt == null) {
      value['createdAt'] = FieldValue.serverTimestamp();
    }
    return value;
  }
}
