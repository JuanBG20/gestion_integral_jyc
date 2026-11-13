import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ExpenseStatusBadge extends StatelessWidget {
  final ExpensePaymentStatus status;

  const ExpenseStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color color, IconData icon, String label) = switch (status) {
      ExpensePaymentStatus.pagado => (Colors.green, Icons.task_alt, 'PAGADO'),
      ExpensePaymentStatus.pendiente => (
        AppColors.deadlineRed,
        Icons.warning_amber_outlined,
        'PENDIENTE DE PAGO',
      ),
    };

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
            label,
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
