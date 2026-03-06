import 'package:flutter/material.dart';

/// Extension on [BuildContext] for getting widget position
/// relative to overlay.
extension ContextRenderBoxPosition on BuildContext {
  /// Gets the position of the widget as a [RelativeRect] relative to the overlay.
  ///
  /// Useful for positioning context menus, tooltips, and popovers.
  /// Returns null if the widget hasn't been rendered yet or overlay not found.
  ///
  /// Example:
  /// ```dart
  /// onPressed: () {
  ///   final position = context.renderBoxRect;
  ///   if (position != null) {
  ///     showMenu(context: context, position: position, items: [...]);
  ///   }
  /// }
  /// ```
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
