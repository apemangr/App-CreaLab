import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutline;

  const CustomBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = theme.colorScheme.primary.withOpacity(0.1);
    final defaultTextColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : (backgroundColor ?? defaultBgColor),
        borderRadius: BorderRadius.circular(4),
        border: isOutline
            ? Border.all(color: backgroundColor ?? theme.colorScheme.outline)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor ?? defaultTextColor,
        ),
      ),
    );
  }
}
