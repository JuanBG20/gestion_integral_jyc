import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_item_card.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_items_list_section.dart';
import 'package:gestion_integral_jyc/core/utils/price_calculator.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';

class ExpenseRawMaterialItemsSection extends ConsumerWidget {
  final List<ExpenseRawMaterialEntity> initialItems;
  final ValueChanged<List<ExpenseRawMaterialEntity>> onItemsChanged;

  const ExpenseRawMaterialItemsSection({
    super.key,
    required this.onItemsChanged,
    this.initialItems = const [],
  });

  String _displayUnitName(MeasurementUnit unit) =>
      unit == MeasurementUnit.gramos ? 'Kg' : unit.name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materials = ref.watch(rawMaterialProvider).value ?? const [];

    return LineItemsListSection<ExpenseRawMaterialEntity, RawMaterialEntity>(
      onItemsChanged: onItemsChanged,
      initialItems: initialItems,
      sectionTitle: "Detalle de Insumos",
      allowGeneric: false,
      decimalQuantity: true,

      options: materials,
      optionLabel: "Insumo",
      optionHint: "Seleccione un insumo...",
      optionItemLabel: (m) => '${m.description} (${m.sku})',

      quantityLabelOf: (m) =>
          m == null ? "Cant." : "Cant. (${m.measurementUnit.abbreviation})",
      priceLabelOf: (_) => "Costo Total (\$)",
      unitPriceFromInput: (m, quantity, totalCost) =>
          quantity <= 0 ? 0 : totalCost / quantity,

      itemBuilder:
          ({
            required option,
            required quantity,
            required unitPrice,
            description,
          }) => ExpenseRawMaterialEntity(
            rawMaterial: option!,
            quantity: quantity,
            unitPrice: unitPrice,
          ),

      itemCardBuilder: (context, item, onDelete) {
        final unit = item.rawMaterial.measurementUnit;
        final displayUnitPrice = PriceCalculator.toDisplayPrice(
          item.unitPrice ?? 0,
          unit,
        );

        return LineItemCard(
          leadingText: item.quantityText,
          title: item.rawMaterial.description,
          amountText: "\$${item.subtotal.toStringAsFixed(2)}",
          amountCaption:
              "\$${displayUnitPrice.toStringAsFixed(2)} / ${_displayUnitName(unit)}",
          onDelete: onDelete,
        );
      },
    );
  }
}
