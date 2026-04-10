import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BootstrapSuccessView extends StatelessWidget {
  const BootstrapSuccessView({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BootstrapSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.green,
                size: 60,
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.5, 0.5),
                )
                .shimmer(delay: 400.ms, duration: 1.seconds),
            const SizedBox(height: BootstrapSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.bold,
            ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: BootstrapSpacing.m),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: BootstrapSpacing.xl),
              BootstrapButton(
                label: actionLabel!,
                onPressed: onAction,
                width: 200,
              ).animate().fade(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
            ],
          ],
        ),
      ),
    );
  }
}
