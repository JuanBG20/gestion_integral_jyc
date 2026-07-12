import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list_section.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';

class WorkItemsListSection extends StatelessWidget {
  final ValueChanged<List<WorkItemEntity>> onItemsChanged;
  final List<WorkItemEntity> initialItems;

  const WorkItemsListSection({
    super.key,
    required this.onItemsChanged,
    this.initialItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ProductItemsListSection<WorkItemEntity>(
      onItemsChanged: onItemsChanged,
      initialItems: initialItems,
      sectionTitle: "Ítems a Producir",
      genericItemLabel: "Ítem Genérico",
      genericDescriptionHint: "Diseño personalizado",
      itemBuilder:
          ({
            required variantProduct,
            required quantity,
            required unitPrice,
            description,
          }) => WorkItemEntity(
            variantProduct: variantProduct,
            quantity: quantity,
            unitPrice: unitPrice,
            description: description,
            isDone: false,
          ),
    );
  }
}
