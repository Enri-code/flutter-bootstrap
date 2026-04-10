import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';

/// A premium error view component for displaying failures in a user-friendly way.
class BootstrapErrorView extends StatelessWidget {
  const BootstrapErrorView({
    required this.message,
    this.title = 'Oops!',
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.textColor,
    this.iconColor,
    super.key,
  });

  const BootstrapErrorView.small({
    required this.message,
    this.onRetry,
    this.textColor,
    this.iconColor,
    super.key,
  }) : title = null,
       icon = Icons.refresh_rounded;

  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isSmall = title == null;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isSmall) ...[
          Container(
            padding: const EdgeInsets.all(BootstrapSpacing.lg),
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.error).withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: iconColor ?? theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: BootstrapSpacing.lg),
          Text(
            title ?? '',
            style: context.textTheme.headlineSmall?.bold.copyWith(
              color: textColor ?? theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: BootstrapSpacing.xs),
        ] else ...[
          Icon(icon, size: 32, color: iconColor ?? theme.colorScheme.error),
          const SizedBox(height: BootstrapSpacing.sm),
        ],
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: textColor ?? theme.hintColor,
          ),
        ),
        if (onRetry != null && !isSmall) ...[
          const SizedBox(height: BootstrapSpacing.xl),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ],
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isSmall ? BootstrapSpacing.md : BootstrapSpacing.lg,
        ),
        child: isSmall && onRetry != null
            ? AnimatedScaleTap(onTap: onRetry, child: content)
            : content,
      ),
    );
  }
}
