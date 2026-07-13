import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class QuickActionsLayout extends StatelessWidget {
  final List<Widget> quickActions;

  const QuickActionsLayout({super.key, required this.quickActions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Acciones Rápidas", style: context.textTheme.titleMedium),

          if (quickActions.isNotEmpty) const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,

            children: quickActions,
          ),
        ],
      ),
    );
  }
}
