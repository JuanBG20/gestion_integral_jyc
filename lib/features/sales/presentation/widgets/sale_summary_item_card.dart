import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';

class SaleSummaryItemCard extends StatelessWidget {
  final SaleItemEntity item;

  const SaleSummaryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final itemName = item.variantProduct != null
        ? '${item.variantProduct!.baseProduct.description} ${item.variantProduct!.color ?? ''}'
              .trim()
        : item.description ?? 'Producto Genérico';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  itemName,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium,
                ),

                Text(item.quantityText, style: context.textTheme.bodySmall),
              ],
            ),
          ),

          Text(
            "\$${item.subtotal.toStringAsFixed(2)}",
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
