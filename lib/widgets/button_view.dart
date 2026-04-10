import 'package:flutter/material.dart';
import 'package:bootstrap/core.dart';
import 'package:bootstrap/definitions/tokens.dart';

enum BootstrapButtonType { primary, secondary, outline, text, danger }

class BootstrapButton extends StatelessWidget {
  const BootstrapButton({
    required this.label,
    required this.onPressed,
    this.type = BootstrapButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.fontSize,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final BootstrapButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    Color bg;
    Color fg;
    var borderSide = BorderSide.none;
    List<BoxShadow>? shadows;

    final isDisabled = onPressed == null || isLoading;

    switch (type) {
      case BootstrapButtonType.primary:
        bg = theme.primaryColor;
        fg = Colors.white;
        if (!isDisabled) {
          shadows = [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ];
        }
      case BootstrapButtonType.secondary:
        bg = theme.primaryColor.withValues(alpha: 0.1);
        fg = theme.primaryColor;
      case BootstrapButtonType.outline:
        bg = Colors.transparent;
        fg = theme.primaryColor;
        borderSide = BorderSide(
          color: theme.dividerColor,
          width: 1.5,
        );
      case BootstrapButtonType.danger:
        bg = theme.colorScheme.error;
        fg = Colors.white;
      case BootstrapButtonType.text:
        bg = Colors.transparent;
        fg = theme.primaryColor;
    }

    // Explicit overrides
    if (backgroundColor != null && type != BootstrapButtonType.outline) {
      bg = backgroundColor!;
    }
    
    if (foregroundColor != null) fg = foregroundColor!;

    if (isDisabled) {
      if (type != BootstrapButtonType.text &&
          type != BootstrapButtonType.outline) {
        bg = theme.disabledColor.withValues(alpha: 0.1);
      }
      fg = theme.disabledColor;
      shadows = null;
    }

    return AnimatedScaleTap(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        padding:
            padding ??
            const EdgeInsets.symmetric(horizontal: BootstrapSpacing.m),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BootstrapRadii.button),
          border: borderSide != BorderSide.none
              ? Border.fromBorderSide(borderSide)
              : null,
          boxShadow: shadows,
        ),
        child: Center(
          child: isLoading
              ? BootstrapInlineLoader(color: fg)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: fg, size: 20),
                      const SizedBox(width: BootstrapSpacing.xs),
                    ],
                    Text(
                      label,
                      style: context.textTheme.titleSmall?.semiBold.copyWith(
                        color: fg,
                        fontSize: fontSize,
                        height: 1.2,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
