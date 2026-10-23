import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_item_card.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_items_list_section.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';

typedef ProductLineItemBuilder<T extends ProductLineItemEntity> =
    T Function({
      required VariantProductEntity? variantProduct,
      required int quantity,
      required double unitPrice,
      String? description,
    });

class ProductItemsListSection<T extends ProductLineItemEntity>
    extends ConsumerWidget {
  final ValueChanged<List<T>> onItemsChanged;
  final ProductLineItemBuilder<T> itemBuilder;
  final String sectionTitle;
  final String genericItemLabel;
  final String genericDescriptionHint;
  final List<T> initialItems;
  final ItemScanListener? scanListener;

  const ProductItemsListSection({
    super.key,
    required this.onItemsChanged,
    required this.itemBuilder,
    this.sectionTitle = "Ítems",
    this.genericItemLabel = "Ítem Genérico",
    this.genericDescriptionHint = "Descripción del ítem",
    this.initialItems = const [],
    this.scanListener,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVariants = ref.watch(flattenedVariantsProvider);

    return LineItemsListSection<T, VariantProductEntity>(
      onItemsChanged: onItemsChanged,
      initialItems: initialItems,
      sectionTitle: sectionTitle,
      genericDescriptionHint: genericDescriptionHint,

      options: allVariants,
      optionLabel: "Producto",
      optionHint: "Seleccione un producto...",
      optionItemLabel: (v) {
        final title =
            '${v.baseProduct.description} ${v.color ?? ''} ${v.size ?? ''}'
                .trim();
        return '$title (${v.sku})';
      },
      defaultPriceOf: (v) => v.salePrice,

      itemBuilder:
          ({
            required option,
            required quantity,
            required unitPrice,
            description,
          }) => itemBuilder(
            variantProduct: option,
            quantity: quantity.toInt(),
            unitPrice: unitPrice,
            description: description,
          ),

      itemCardBuilder: (context, item, onDelete) {
        final variant = item.variantProduct;
        final name = variant != null
            ? '${variant.baseProduct.description} ${variant.color ?? ''}'.trim()
            : item.description ?? genericItemLabel;

        return LineItemCard(
          leadingText: '${item.quantity}x',
          title: name,
          subtitle: variant?.sku,
          amountText:
              "\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}",
          onDelete: onDelete,
        );
      },

      scanListener: scanListener,
      scanCodeOf: (v) => v.sku,
      scanNotFoundMessage: (sku) => 'SKU no encontrado en inventario: $sku',
    );
  }
}
