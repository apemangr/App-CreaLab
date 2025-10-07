import 'package:flutter/material.dart';

enum MetricColor {
  cyan,
  purple,
  green,
  orange,
}

class BentoMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final String? unit;
  final MetricColor color;

  const BentoMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.color = MetricColor.cyan,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorStyles = _getColorStyles(isDark);

    return Container(
      decoration: BoxDecoration(
        gradient: colorStyles['gradient'] as LinearGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorStyles['border'] as Color,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorStyles['iconBg'] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorStyles['iconColor'] as Color,
            ),
          ),
          const SizedBox(height: 8),
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getColorStyles(bool isDark) {
    switch (color) {
      case MetricColor.cyan:
        return {
          'gradient': LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF06B6D4).withOpacity(0.2),
                    const Color(0xFF3B82F6).withOpacity(0.1),
                  ]
                : [
                    const Color(0xFF06B6D4).withOpacity(0.1),
                    const Color(0xFF3B82F6).withOpacity(0.05),
                  ],
          ),
          'iconBg': isDark
              ? const Color(0xFF06B6D4).withOpacity(0.2)
              : const Color(0xFF06B6D4).withOpacity(0.1),
          'iconColor': isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
          'border': isDark
              ? const Color(0xFF06B6D4).withOpacity(0.3)
              : const Color(0xFF06B6D4).withOpacity(0.2),
        };
      case MetricColor.purple:
        return {
          'gradient': LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFFA855F7).withOpacity(0.2),
                    const Color(0xFFEC4899).withOpacity(0.1),
                  ]
                : [
                    const Color(0xFFA855F7).withOpacity(0.1),
                    const Color(0xFFEC4899).withOpacity(0.05),
                  ],
          ),
          'iconBg': isDark
              ? const Color(0xFFA855F7).withOpacity(0.2)
              : const Color(0xFFA855F7).withOpacity(0.1),
          'iconColor': isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
          'border': isDark
              ? const Color(0xFFA855F7).withOpacity(0.3)
              : const Color(0xFFA855F7).withOpacity(0.2),
        };
      case MetricColor.green:
        return {
          'gradient': LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF22C55E).withOpacity(0.2),
                    const Color(0xFF10B981).withOpacity(0.1),
                  ]
                : [
                    const Color(0xFF22C55E).withOpacity(0.1),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ],
          ),
          'iconBg': isDark
              ? const Color(0xFF22C55E).withOpacity(0.2)
              : const Color(0xFF22C55E).withOpacity(0.1),
          'iconColor': isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
          'border': isDark
              ? const Color(0xFF22C55E).withOpacity(0.3)
              : const Color(0xFF22C55E).withOpacity(0.2),
        };
      case MetricColor.orange:
        return {
          'gradient': LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFFF97316).withOpacity(0.2),
                    const Color(0xFFF59E0B).withOpacity(0.1),
                  ]
                : [
                    const Color(0xFFF97316).withOpacity(0.1),
                    const Color(0xFFF59E0B).withOpacity(0.05),
                  ],
          ),
          'iconBg': isDark
              ? const Color(0xFFF97316).withOpacity(0.2)
              : const Color(0xFFF97316).withOpacity(0.1),
          'iconColor': isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
          'border': isDark
              ? const Color(0xFFF97316).withOpacity(0.3)
              : const Color(0xFFF97316).withOpacity(0.2),
        };
    }
  }
}
