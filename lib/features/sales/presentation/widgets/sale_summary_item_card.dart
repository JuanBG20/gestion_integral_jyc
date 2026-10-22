import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/base_summary_item_card.dart';
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

    return BaseSummaryItemCard(
      title: itemName,
      subtitle: item.quantityText,
      subtotal: "\$${item.subtotal.toStringAsFixed(2)}",
    );
  }
}
