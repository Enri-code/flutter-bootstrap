import 'package:flutter/material.dart';
import 'package:bootstrap/core.dart';

class BootstrapInfoTile extends StatelessWidget {
  const BootstrapInfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.onTap,
    this.isBold = false,
    this.isDimmed = false,
    this.fontSize,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool isBold;
  final bool isDimmed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final hintColor = theme.hintColor;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (iconColor ?? hintColor).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: iconColor ?? theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: hintColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDimmed
                          ? hintColor
                          : theme.textTheme.bodyMedium?.color,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                      fontSize: fontSize ?? (isBold ? 14 : 13),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: hintColor.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
