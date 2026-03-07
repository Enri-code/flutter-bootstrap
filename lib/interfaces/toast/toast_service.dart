import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

abstract class IToastService {
  void showCustomToast(Widget toast);

  void showToast(
    String message, {
    required ToastType type,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  });
  void showLoading(String message);
  void dismiss();
}
