import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BootstrapEmptyView extends StatelessWidget {
  const BootstrapEmptyView({
    required this.icon,
    required this.title,
    this.description,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            )
                .animate()
                .scale(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.6, 0.6),
                ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.bold.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.15, curve: Curves.easeOut),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.15, curve: Curves.easeOut),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ].animate().fadeIn(delay: 350.ms).slideY(begin: 0.15, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
