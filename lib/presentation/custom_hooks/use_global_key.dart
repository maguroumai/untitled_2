import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() {
  return useState(GlobalKey<T>()).value;
}

GlobalKey<FormFieldState<String>> useFormFieldStateKey({String? debugLabel}) {
  return useState(GlobalKey<FormFieldState<String>>(debugLabel: debugLabel))
      .value;
}
