import 'package:bootstrap/interfaces/toast/toast_service.dart';
import 'package:flutter/material.dart';

class ToastServiceProvider extends InheritedWidget {
  const ToastServiceProvider({
    required this.service,
    required super.child,
    super.key,
  });

  final IToastService service;

  static IToastService of(BuildContext context) {
    final service = maybeOf(context);
    assert(service != null, 'ToastServiceProvider not found in widget tree');
    return service!;
  }

  static IToastService? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ToastServiceProvider>()
        ?.service;
  }

  @override
  bool updateShouldNotify(ToastServiceProvider oldWidget) =>
      service != oldWidget.service;
}

extension ToastServiceExtension on BuildContext {
  IToastService get toast => ToastServiceProvider.of(this);
  IToastService? get toastOrNull => ToastServiceProvider.maybeOf(this);
}
