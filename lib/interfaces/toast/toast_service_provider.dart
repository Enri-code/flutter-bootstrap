import 'package:bootstrap/interfaces/toast/toast_service.dart';
import 'package:flutter/material.dart';

class ToastServiceProvider extends InheritedWidget {
  const ToastServiceProvider({
    required this.service,
    required super.child,
    super.key,
  });

  final IToastService service;

  static IToastService? of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ToastServiceProvider>();
    assert(provider != null, 'ToastServiceProvider not found in widget tree');
    return provider?.service;
  }

  @override
  bool updateShouldNotify(ToastServiceProvider oldWidget) =>
      service != oldWidget.service;
}
