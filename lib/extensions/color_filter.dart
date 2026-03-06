import 'dart:ui';

/// A ColorFilter that applies the source color using [BlendMode.srcIn].
///
/// This blend mode displays the source color only where the destination
/// (original image/widget) has alpha. Useful for tinting icons and images.
///
/// Example:
/// ```dart
/// Image.asset(
///   'assets/icon.png',
///   colorFilter: SrcInColorFilter(Colors.blue),
/// )
/// ```
class SrcInColorFilter extends ColorFilter {
  const SrcInColorFilter(Color color) : super.mode(color, BlendMode.srcIn);
}
