import 'package:flutter/material.dart';

abstract class IToastService {
  Future<void> showToast({
    required String msg,
    double fontSize = 14,
    Color? backgroundColor,
    Color? textColor,
  });

  void showCustomToast(Widget toast);
}
