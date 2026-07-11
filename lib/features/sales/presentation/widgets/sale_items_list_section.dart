import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list_section.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';

class SaleItemsListSection extends StatelessWidget {
  final ValueChanged<List<SaleItemEntity>> onItemsChanged;

  const SaleItemsListSection({super.key, required this.onItemsChanged});

  @override
  Widget build(BuildContext context) {
    return ProductItemsListSection<SaleItemEntity>(
      onItemsChanged: onItemsChanged,
      sectionTitle: "Agregar Producto",
      genericItemLabel: "Producto Genérico",
      genericDescriptionHint: "Soporte para Celular",
      itemBuilder:
          ({
            required variantProduct,
            required quantity,
            required unitPrice,
            description,
          }) => SaleItemEntity(
            variantProduct: variantProduct,
            quantity: quantity,
            unitPrice: unitPrice,
            description: description,
          ),
    );
  }
}
