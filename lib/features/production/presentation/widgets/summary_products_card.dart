import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SummaryProductsCard extends StatelessWidget {
  final double subtotal;

  const SummaryProductsCard({super.key, required this.subtotal});

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
              Text("Productos", style: context.textTheme.bodyMedium),
              Text("\$$subtotal", style: context.textTheme.bodyMedium),
            ],
          ),

          const SizedBox(height: 8),

          Divider(color: AppColors.outline),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Total", style: context.textTheme.titleMedium),
              Text("\$$subtotal", style: context.textTheme.titleLarge),
            ],
          ),
        ],
      ),
    );
  }
}
