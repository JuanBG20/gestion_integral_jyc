import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ProductLineItemCard<T extends ProductLineItemEntity>
    extends StatelessWidget {
  final T item;
  final String genericItemLabel;
  final VoidCallback onDelete;

  const ProductLineItemCard({
    super.key,
    required this.item,
    required this.genericItemLabel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemName = item.variantProduct != null
        ? '${item.variantProduct!.baseProduct.description} ${item.variantProduct!.color ?? ''}'
              .trim()
        : item.description ?? genericItemLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),

            child: Text(
              '${item.quantity}x',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  itemName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.variantProduct?.sku != null)
                  Text(
                    item.variantProduct!.sku,
                    style: context.textTheme.bodySmall,
                  ),
              ],
            ),
          ),

          Text(
            "\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}",
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 16),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Eliminar ítem',
          ),
        ],
      ),
    );
  }
}

/* 

Widget _buildItemCard(T item, int index) {
    
  }
 */
