import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/variants_table_section.dart';

class VariantCard extends StatelessWidget {
  final VariantFormData variant;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VariantCard({
    super.key,
    required this.variant,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isGrams = variant.measurementUnit == MeasurementUnit.gramos;
    final unitSymbol = variant.measurementUnit.abbreviation;

    final displaySalePrice = isGrams
        ? variant.salePrice * 1000
        : variant.salePrice;
    final displayCostPrice = isGrams
        ? variant.costPrice * 1000
        : variant.costPrice;
    final priceLabel = isGrams ? 'Kg' : 'u';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  variant.sku,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${variant.color.isNotEmpty ? variant.color : "-"} · ${variant.size} · Stock: ${variant.stock} $unitSymbol',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                "\$${displaySalePrice.toStringAsFixed(2)} / $priceLabel",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Costo: \$${displayCostPrice.toStringAsFixed(2)} / $priceLabel",
                style: context.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(width: 16),

          Icon(
            Icons.science_outlined,
            color: variant.recipe.isNotEmpty
                ? AppColors.primary
                : AppColors.onBackground,
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            tooltip: 'Editar variante',
          ),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Eliminar variante',
          ),
        ],
      ),
    );
  }
}
