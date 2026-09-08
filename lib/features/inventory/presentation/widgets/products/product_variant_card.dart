import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/product_action_handler.dart';

class ProductVariantCard extends ConsumerWidget {
  final VariantProductEntity variant;
  final bool isAdmin;

  const ProductVariantCard({
    super.key,
    required this.variant,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributes = [
      variant.color,
      variant.size,
    ].where((e) => e != null && e.isNotEmpty).join(' - ');

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.onBackground.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outline),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(variant.sku, style: context.textTheme.titleSmall),
              ),

              AppActionMenu(
                items: [
                  const AppActionMenuItem(
                    value: 'update',
                    label: 'Ajustar Stock',
                  ),
                  if (isAdmin)
                    const AppActionMenuItem(
                      value: 'delete',
                      label: 'Eliminar Variante',
                      isDestructive: true,
                    ),
                ],
                onSelected: (value) => handleVariantProductSharedAction(
                  context,
                  ref,
                  variant,
                  value,
                  isAdmin,
                ),
              ),
            ],
          ),

          if (attributes.isNotEmpty) ...[
            Text(attributes, style: context.textTheme.bodyMedium),

            const SizedBox(height: 4),
          ],

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              _buildVariantStat(context, "Stock", variant.formattedStock),
              _buildVariantStat(
                context,
                "Costo",
                "\$${variant.costPrice.toStringAsFixed(2)}",
              ),
              _buildVariantStat(
                context,
                "Venta",
                "\$${variant.salePrice.toStringAsFixed(2)}",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(label, style: context.textTheme.bodySmall),

        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
