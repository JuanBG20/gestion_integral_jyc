import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class CategoryBudget extends StatelessWidget {
  final String text;

  const CategoryBudget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.onBackground.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),

      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
    );
  }
}
