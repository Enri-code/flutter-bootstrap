import 'package:flutter/material.dart';

extension ContextRenderBoxPosition on BuildContext {
  RelativeRect? get renderBoxRect {
    final renderBox = findRenderObject() as RenderBox?;
    final overlay = Overlay.of(this).context.findRenderObject() as RenderBox?;

    if (renderBox == null || overlay == null) return null;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    return position;
  }
}
