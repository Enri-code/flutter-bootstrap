import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';


class BootstrapCard extends StatelessWidget {
  const BootstrapCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.width,
    this.height,
    this.color = Colors.white,
    this.borderColor,
    this.shadowColor,
    this.borderRadius,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Color color;
  final Color? borderColor;
  final Color? shadowColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? theme.dividerColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: Padding(padding: padding, child: child),
      ),
    );

    if (onTap != null) {
      return AnimatedScaleTap(onTap: onTap, child: card);
    }

    return card;
  }
}
