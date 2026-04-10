import 'package:flutter/material.dart';

class BootstrapShimmer extends StatelessWidget {
  const BootstrapShimmer({
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
   return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor ?? Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}
