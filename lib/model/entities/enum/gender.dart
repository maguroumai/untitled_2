import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum Gender {
  none,
  man,
  woman,
}

class GenderConverter implements JsonConverter<Gender?, String?> {
  const GenderConverter();

  @override
  Gender? fromJson(String? value) => value?.toGender;

  @override
  String? toJson(Gender? object) => object?.name;
}

extension GenderExtension on Gender {
  String getLabel(BuildContext context) {
    if (this == Gender.man) {
      return '男性';
    } else if (this == Gender.woman) {
      return '女性';
    }
    return '-';
  }
}

extension GenderStringExtension on String {
  Gender get toGender {
    if (this == Gender.man.name) {
      return Gender.man;
    } else if (this == Gender.woman.name) {
      return Gender.woman;
    }
    return Gender.none;
  }

  Gender getToGenderWithLabel(BuildContext context) {
    if (this == Gender.man.getLabel(context)) {
      return Gender.man;
    } else if (this == Gender.woman.getLabel(context)) {
      return Gender.woman;
    }
    return Gender.none;
  }
}

class MaterialTapGesture extends StatelessWidget {
  const MaterialTapGesture({
    Key? key,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : super(key: key);

  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      color: Colors.white,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
