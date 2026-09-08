import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

void handleBaseProductSharedAction(
  BuildContext context,
  WidgetRef ref,
  ProductGroupUi product,
  String action,
) {
  switch (action) {
    case 'edit':
      context.go('/inventory/edit-product', extra: product);
    case 'delete':
      if (product.baseProduct.id != null) {
        ref
            .read(inventoryProductsProvider.notifier)
            .removeProductWithVariants(product.baseProduct.id!);
      }
  }
}

void handleVariantProductSharedAction(
  BuildContext context,
  WidgetRef ref,
  VariantProductEntity variant,
  String action,
  bool isAdmin,
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
        ref.read(inventoryProductsProvider.notifier).removeVariant(variant.id!);
      }
  }
}
