import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SaleStatusBadge extends StatelessWidget {
  final String status;

  const SaleStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.primary;
    IconData icon = Icons.description_outlined;

    switch (status) {
      case 'PENDIENTE DE PAGO':
        color = AppColors.deadlineRed;
        icon = Icons.warning_amber_outlined;

      case 'FACTURADA':
        color = Colors.green;
        icon = Icons.task_alt;

      case 'SIN FACTURAR':
        color = AppColors.primary;
        icon = Icons.description_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Icon(icon, size: 16, color: color),

          const SizedBox(width: 8),

          Text(
            status,
            style: context.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
