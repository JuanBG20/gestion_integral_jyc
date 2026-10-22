import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/base_summary_item_card.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';

class ExpenseSummaryItemCard extends StatelessWidget {
  final ExpenseRawMaterialEntity item;

  const ExpenseSummaryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BaseSummaryItemCard(
      title: item.rawMaterial.description,
      subtitle: item.quantityText,
      subtotal: "\$${item.subtotal.toStringAsFixed(2)}",
    );
  }
}
