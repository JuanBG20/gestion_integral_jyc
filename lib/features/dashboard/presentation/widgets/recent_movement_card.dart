import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class RecentMovementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const RecentMovementCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: color),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(title, style: context.textTheme.bodyMedium),
            Text(subtitle, style: context.textTheme.bodyLarge),
            Text(time, style: context.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
