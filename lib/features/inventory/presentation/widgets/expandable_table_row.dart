import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

class ExpandableTableRow extends ConsumerWidget {
  final ProductGroupUi product;
  final bool isAdmin;

  const ExpandableTableRow({
    super.key,
    required this.product,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = product.baseProduct;

    return ExpansionTile(
      tilePadding: const EdgeInsets.only(left: 24, right: 24),

      leading: Icon(Icons.keyboard_arrow_down),

      trailing: AppActionMenu(
        items: [
          const AppActionMenuItem(value: 'edit', label: 'Editar'),
          if (isAdmin)
            const AppActionMenuItem(
              value: 'delete',
              label: 'Eliminar',
              isDestructive: true,
            ),
        ],
        onSelected: (value) => _handleBaseAction(context, ref, base, value),
      ),

      title: Row(
        children: [
          Expanded(flex: 2, child: Text(base.baseSku)),
          Expanded(flex: 3, child: Text(base.description)),
          Expanded(flex: 1, child: Text('${product.totalStock}u. Total')),
          Expanded(flex: 3, child: Text(base.fullCategory)),
          Expanded(flex: 2, child: Text("")),
          Expanded(flex: 2, child: Text("")),
        ],
      ),

      children: product.variants
          .map(
            (variant) => AppTableRow(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 60,
                right: 24,
              ),
              background: AppColors.surface,
              trailingWidth: 40,
              trailing: AppActionMenu(
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
                onSelected: (value) =>
                    _handleProductAction(context, ref, variant, value),
              ),

              cells: [
                AppTableCell.text(variant.sku, flex: 2),
                AppTableCell.text(
                  [
                    variant.color,
                    variant.size,
                  ].where((e) => e != null && e.isNotEmpty).join(' - '),
                  flex: 3,
                ),
                AppTableCell.text(variant.formattedStock, flex: 1),
                AppTableCell.text("", flex: 3),
                AppTableCell.text(
                  '\$${variant.costPrice.toStringAsFixed(2)}',
                  flex: 2,
                ),
                AppTableCell.text(
                  '\$${variant.salePrice.toStringAsFixed(2)}',
                  flex: 2,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  void _handleProductAction(
    BuildContext context,
    WidgetRef ref,
    VariantProductEntity variant,
    String action,
  ) {
    final base = variant.baseProduct;

    switch (action) {
      case 'update':
        showStockDialog(
          context: context,
          title:
              'Stock: ${base.description} (${variant.color ?? variant.size ?? variant.sku})',
          isProduct: true,
          isAdmin: isAdmin,
          onConfirm: (delta, deductMp) async {
            if (variant.id != null) {
              await ref
                  .read(inventoryProductsProvider.notifier)
                  .updateStock(variant.id!, delta, deductMp);

              if (delta > 0 && deductMp) {
                ref.read(rawMaterialProvider.notifier).fetchRawMaterials();
              }
            }
          },
        );
      case 'delete':
        if (variant.id != null) {
          ref
              .read(inventoryProductsProvider.notifier)
              .removeVariant(variant.id!);
        }
    }
  }

  void _handleBaseAction(
    BuildContext context,
    WidgetRef ref,
    BaseProductEntity base,
    String action,
  ) {
    switch (action) {
      case 'edit':
        context.go('/inventory/edit-product', extra: product);
      case 'delete':
        if (base.id != null) {
          ref
              .read(inventoryProductsProvider.notifier)
              .removeProductWithVariants(base.id!);
        }
    }
  }
}
