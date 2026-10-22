import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_searchable_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/utils/price_calculator.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';

class AddExpenseMaterialDialog extends ConsumerStatefulWidget {
  const AddExpenseMaterialDialog({super.key});

  @override
  ConsumerState<AddExpenseMaterialDialog> createState() =>
      _AddExpenseMaterialDialogState();
}

class _AddExpenseMaterialDialogState
    extends ConsumerState<AddExpenseMaterialDialog> {
  RawMaterialEntity? _selectedMaterial;
  final _qtyController = TextEditingController();
  final _lineCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _qtyController.addListener(() => setState(() {}));
    _lineCostController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _lineCostController.dispose();
    super.dispose();
  }

  String get _calculatedUnitCost {
    if (_selectedMaterial == null) return '\$0.00';

    final qty = double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 0;
    final cost =
        double.tryParse(_lineCostController.text.replaceAll(',', '.')) ?? 0;
    if (qty <= 0) return '\$0.00';

    final dbUnitPrice = cost / qty;

    final displayPrice = PriceCalculator.toDisplayPrice(
      dbUnitPrice,
      _selectedMaterial!.measurementUnit,
    );
    final isGrams =
        _selectedMaterial!.measurementUnit == MeasurementUnit.gramos;
    final priceLabel = isGrams ? 'Kg' : _selectedMaterial!.measurementUnit.name;

    return "\$ ${displayPrice.toStringAsFixed(2)} / $priceLabel";
  }

  void _confirm() {
    if (_selectedMaterial == null) return;

    final qty = double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 0;
    final cost =
        double.tryParse(_lineCostController.text.replaceAll(',', '.')) ?? 0;

    if (qty <= 0) return;

    final unitPrice = cost / qty;

    final result = ExpenseRawMaterialEntity(
      rawMaterial: _selectedMaterial!,
      quantity: qty,
      unitPrice: unitPrice,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsState = ref.watch(rawMaterialProvider);
    final unitLabel = _selectedMaterial?.measurementUnit.dbValue ?? 'unid.';

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        "Añadir Insumo a la Compra",
        style: context.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: 400,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            rawMaterialsState.when(
              data: (materials) => LabeledSearchableDropdown<RawMaterialEntity>(
                label: "Material en Inventario",
                value: _selectedMaterial,
                items: materials,
                itemLabel: (m) => '${m.description} (${m.sku})',
                hint: "Buscar material...",
                onChanged: (val) {
                  setState(() {
                    _selectedMaterial = val;
                  });
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error al cargar: $e'),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    controller: _qtyController,
                    label: "Cantidad ($unitLabel)",
                    hint: "10",
                    inputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: LabeledTextField(
                    controller: _lineCostController,
                    label: "Costo Total",
                    hint: "0.00",
                    prefixIcon: const Icon(Icons.attach_money, size: 18),
                    inputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.onBackground.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Costo unitario calculado:",
                    style: context.textTheme.bodySmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _calculatedUnitCost,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _selectedMaterial == null ? null : _confirm,
          icon: const Icon(Icons.add),
          label: const Text('Añadir al Gasto'),
        ),
      ],
    );
  }
}
