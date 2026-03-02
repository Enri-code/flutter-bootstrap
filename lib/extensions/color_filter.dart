import 'dart:ui';

class SrcInColorFilter extends ColorFilter {
  const SrcInColorFilter(Color color) : super.mode(color, BlendMode.srcIn);
}
