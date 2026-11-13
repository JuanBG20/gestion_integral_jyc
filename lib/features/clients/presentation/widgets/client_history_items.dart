import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/line_item_formatting.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ClientHistoryItems extends StatelessWidget {
  final List<ProductLineItemEntity> items;

  const ClientHistoryItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('Sin ítems', style: context.textTheme.bodySmall);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    _quantityText(item),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    item.variantLabel != null
                        ? '${item.displayName} (${item.variantLabel})'
                        : item.displayName,
                    style: context.textTheme.bodySmall,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '\$${item.unitPrice.toStringAsFixed(2)} c/u',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _quantityText(ProductLineItemEntity item) {
    final variant = item.variantProduct;
    return variant != null
        ? '${item.quantity}${variant.measurementUnit.abbreviation}'
        : '${item.quantity}u.';
  }
}
