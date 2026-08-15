import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SummaryProductsCard extends StatelessWidget {
  final double totalAmount;
  final double totalPaid;
  final double totalOutstanding;

  const SummaryProductsCard({
    super.key,
    required this.totalAmount,
    required this.totalPaid,
    required this.totalOutstanding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Resumen", style: context.textTheme.titleMedium),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Total Productos", style: context.textTheme.bodyMedium),
              Text("\$$totalAmount", style: context.textTheme.bodyMedium),
            ],
          ),

          if (totalPaid != 0.0) ...[
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Señas Abonadas", style: context.textTheme.bodyMedium),
                Text("-\$$totalPaid", style: context.textTheme.bodyMedium),
              ],
            ),
          ],

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Saldo a Pagar", style: context.textTheme.titleMedium),

              const SizedBox(width: 16),

              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,

                  child: Text(
                    "\$$totalOutstanding",
                    style: context.textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
