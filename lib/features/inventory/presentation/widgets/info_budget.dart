import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class InfoBudget extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;

  const InfoBudget({super.key, required this.text, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            color?.withValues(alpha: 0.2) ??
            AppColors.onBackground.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          if (icon != null) ...[
            Icon(icon!, size: 14, color: color ?? AppColors.onBackground),

            const SizedBox(width: 4),
          ],

          Text(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
