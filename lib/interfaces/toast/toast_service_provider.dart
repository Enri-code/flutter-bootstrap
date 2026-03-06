import 'package:bootstrap/interfaces/toast/toast_service.dart';
import 'package:flutter/material.dart';

/// An InheritedWidget that provides access to [IToastService].
///
/// Wrap your app with this provider to make toast service available
/// throughout the widget tree.
///
/// Example:
/// ```dart
/// ToastServiceProvider(
///   service: MyToastServiceImpl(),
///   child: MaterialApp(...),
/// )
/// ```
class ToastServiceProvider extends InheritedWidget {
  const ToastServiceProvider({
    required this.service,
    required super.child,
    super.key,
  });

  final IToastService service;

  /// Retrieves the [IToastService] from the widget tree.
  ///
  /// Throws [StateError] if ToastServiceProvider is not found.
  static IToastService of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ToastServiceProvider>();

    if (provider == null) {
      throw StateError(
        'ToastServiceProvider not found in widget tree. '
        'Wrap your app with ToastServiceProvider.',
      );
    }

    return provider.service;
  }

  @override
  bool updateShouldNotify(ToastServiceProvider oldWidget) =>
      service != oldWidget.service;
}
