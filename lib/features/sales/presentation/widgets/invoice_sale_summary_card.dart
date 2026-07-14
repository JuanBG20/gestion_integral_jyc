import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class InvoiceSaleSummaryCard extends StatelessWidget {
  final SaleEntity sale;

  const InvoiceSaleSummaryCard({super.key, required this.sale});

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
          Text("Venta Seleccionada", style: context.textTheme.titleMedium),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          Text(
            sale.client.fullName,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          Text('VTA-${sale.id ?? '---'}', style: context.textTheme.bodySmall),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Total a Facturar", style: context.textTheme.bodyMedium),
              Text(
                "\$${sale.finalAmount.toStringAsFixed(2)}",
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
