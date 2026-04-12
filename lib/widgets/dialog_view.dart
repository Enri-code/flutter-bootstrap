import 'dart:ui';

import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';

enum BootstrapDialogType { info, success, warning, error, destructive }

class BootstrapDialog extends StatelessWidget {
  const BootstrapDialog({
    required this.title,
    required this.content,
    this.type = BootstrapDialogType.info,
    this.icon,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryActionText,
    this.secondaryActionText,
    this.actionsBuilder,
    this.isDestructive = false,
    this.iconColor,
    super.key,
  });

  final String title;
  final String content;
  final BootstrapDialogType type;
  final IconData? icon;
  final String? primaryActionText;
  final String? secondaryActionText;
  final void Function(BuildContext context)? onPrimaryAction;
  final void Function(BuildContext context)? onSecondaryAction;
  final List<Widget> Function(BuildContext context)? actionsBuilder;
  final bool isDestructive;
  final Color? iconColor;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    BootstrapDialogType type = BootstrapDialogType.info,
    IconData? icon,
    String? primaryActionText,
    String? secondaryActionText,
    void Function(BuildContext context)? onPrimaryAction,
    void Function(BuildContext context)? onSecondaryAction,
    List<Widget> Function(BuildContext context)? actionsBuilder,
    Color? iconColor,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'BootstrapDialog',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, _) => BootstrapDialog(
        title: title,
        content: content,
        type: type,
        icon: icon,
        primaryActionText: primaryActionText,
        secondaryActionText: secondaryActionText,
        onPrimaryAction: onPrimaryAction,
        onSecondaryAction: onSecondaryAction,
        actionsBuilder: actionsBuilder,
        iconColor: iconColor,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5 * animation.value,
            sigmaY: 5 * animation.value,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final effectiveType = isDestructive
        ? BootstrapDialogType.destructive
        : type;

    final color =
        iconColor ??
        switch (effectiveType) {
          BootstrapDialogType.success => Colors.green,
          BootstrapDialogType.warning => Colors.orange,
          BootstrapDialogType.error ||
          BootstrapDialogType.destructive => theme.colorScheme.error,
          _ => theme.primaryColor,
        };

    final effectiveIcon =
        icon ??
        switch (effectiveType) {
          BootstrapDialogType.success => Icons.check_circle_rounded,
          BootstrapDialogType.warning => Icons.warning_rounded,
          BootstrapDialogType.error ||
          BootstrapDialogType.destructive => Icons.error_rounded,
          _ => Icons.info_rounded,
        };

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(effectiveIcon, color: color, size: 32),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge?.bold,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (actionsBuilder != null)
                    ...actionsBuilder!(context)
                  else ...[
                    BootstrapButton(
                      onPressed: onPrimaryAction != null
                          ? () => onPrimaryAction!(context)
                          : () => Navigator.pop(context),
                      label: primaryActionText ?? 'OK',
                      backgroundColor: color,
                    ),
                    if (secondaryActionText != null) ...[
                      const SizedBox(height: 12),
                      BootstrapButton(
                        onPressed: onSecondaryAction != null
                            ? () => onSecondaryAction!(context)
                            : () => Navigator.pop(context),
                        label: secondaryActionText!,
                        type: BootstrapButtonType.text,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.hintColor,
                  size: 24,
                ),
                visualDensity: VisualDensity.compact,
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
