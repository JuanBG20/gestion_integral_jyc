import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/utils/price_calculator.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/recipe_dialog.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/variants_table_section.dart';

class VariantFormEditor extends StatefulWidget {
  final VariantFormData? initialVariant;
  final ValueChanged<VariantFormData> onSave;
  final VoidCallback onCancel;

  const VariantFormEditor({
    super.key,
    this.initialVariant,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<VariantFormEditor> createState() => _VariantFormEditorState();
}

class _VariantFormEditorState extends State<VariantFormEditor> {
  final _skuController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController();
  final _costController = TextEditingController();
  final _saleController = TextEditingController();

  MeasurementUnit _selectedUnit = MeasurementUnit.unidad;
  List<MaterialRecipeEntity> _recipe = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialVariant != null) {
      final variant = widget.initialVariant!;

      _skuController.text = variant.sku;
      _colorController.text = variant.color;
      _sizeController.text = variant.size == '-' ? '' : variant.size;
      _stockController.text = variant.stock.toString();
      _costController.text = PriceCalculator.toDisplayPrice(
        variant.costPrice,
        variant.measurementUnit,
      ).toStringAsFixed(2);
      _saleController.text = PriceCalculator.toDisplayPrice(
        variant.salePrice,
        variant.measurementUnit,
      ).toStringAsFixed(2);
      _selectedUnit = variant.measurementUnit;
      _recipe = List.from(variant.recipe);
    }
  }

  @override
  void dispose() {
    _skuController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _stockController.dispose();
    _costController.dispose();
    _saleController.dispose();
    super.dispose();
  }

  void _submit() {
    double rawCost =
        double.tryParse(_costController.text.replaceAll(',', '.')) ?? 0.0;
    double rawSale =
        double.tryParse(_saleController.text.replaceAll(',', '.')) ?? 0.0;

    final finalCost = PriceCalculator.toDatabasePrice(rawCost, _selectedUnit);
    final finalSale = PriceCalculator.toDatabasePrice(rawSale, _selectedUnit);

    final variant = VariantFormData(
      id: widget.initialVariant?.id,
      sku: _skuController.text.trim(),
      color: _colorController.text.trim(),
      size: _sizeController.text.trim().isEmpty
          ? '-'
          : _sizeController.text.trim(),
      stock: int.tryParse(_stockController.text) ?? 0,
      costPrice: finalCost,
      salePrice: finalSale,
      recipe: List.from(_recipe),
      measurementUnit: _selectedUnit,
    );

    widget.onSave(variant);
  }

  Future<void> _openRecipeDialog() async {
    final updatedRecipe = await showDialog<List<MaterialRecipeEntity>>(
      context: context,
      builder: (context) => RecipeDialog(initialRecipe: _recipe),
    );

    if (updatedRecipe != null) {
      setState(() {
        _recipe = updatedRecipe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 500;
        final double thirdWidth = isWide
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth;
        final double halfWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;

        final isGrams = _selectedUnit == MeasurementUnit.gramos;
        final unitSymbol = _selectedUnit.abbreviation;

        return Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,

              children: [
                SizedBox(
                  width: thirdWidth,
                  child: LabeledTextField(
                    controller: _skuController,
                    label: "SKU",
                    hint: "PR-001-BCO",
                  ),
                ),

                SizedBox(
                  width: thirdWidth,
                  child: LabeledTextField(
                    controller: _colorController,
                    label: "Color",
                    hint: "Blanco",
                  ),
                ),

                SizedBox(
                  width: thirdWidth,
                  child: LabeledTextField(
                    controller: _sizeController,
                    label: "Tamaño",
                    hint: "40x40cm",
                  ),
                ),

                SizedBox(
                  width: halfWidth,
                  child: LabeledDropdown<MeasurementUnit>(
                    label: "Unidad de Medida",
                    value: _selectedUnit,
                    hint: "Seleccione una unidad...",
                    items: MeasurementUnit.values
                        .map(
                          (u) =>
                              DropdownMenuItem(value: u, child: Text(u.label)),
                        )
                        .toList(),
                    onChanged: (val) => setState(
                      () => _selectedUnit = val ?? MeasurementUnit.unidad,
                    ),
                  ),
                ),

                SizedBox(
                  width: halfWidth,
                  child: LabeledTextField(
                    controller: _stockController,
                    label: "Stock ($unitSymbol)",
                    hint: "0",
                    inputType: TextInputType.number,
                  ),
                ),

                SizedBox(
                  width: halfWidth,
                  child: LabeledTextField(
                    controller: _costController,
                    label: isGrams
                        ? "Precio de Costo por Kg (\$)"
                        : "Precio Costo (\$)",
                    hint: "0.00",
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),

                SizedBox(
                  width: halfWidth,
                  child: LabeledTextField(
                    controller: _saleController,
                    label: isGrams
                        ? "Precio de Venta por Kg (\$)"
                        : "Precio Venta (\$)",
                    hint: "0.00",
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildActionButtons(isWide),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(bool isWide) {
    final recipeButton = OutlinedButton.icon(
      onPressed: _openRecipeDialog,
      label: Text(
        _recipe.isEmpty ? "Definir Receta" : "Receta (${_recipe.length})",
      ),
      icon: Icon(
        Icons.science_outlined,
        color: _recipe.isNotEmpty ? AppColors.primary : null,
      ),
    );

    final cancelButton = OutlinedButton.icon(
      onPressed: widget.onCancel,
      label: Text("Cancelar"),
      icon: const Icon(Icons.close),
    );

    final saveButton = ElevatedButton.icon(
      onPressed: _submit,
      label: Text(
        widget.initialVariant != null ? "Guardar Cambios" : "Agregar Variante",
      ),
      icon: Icon(widget.initialVariant != null ? Icons.check : Icons.add),
    );

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          recipeButton,

          Row(
            mainAxisSize: MainAxisSize.min,

            children: [cancelButton, const SizedBox(width: 16), saveButton],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        recipeButton,

        const SizedBox(height: 16),

        if (context.isMobileLayout) ...[
          cancelButton,

          const SizedBox(height: 16),

          saveButton,
        ] else
          Row(
            children: [
              Expanded(child: cancelButton),

              const SizedBox(width: 16),

              Expanded(child: saveButton),
            ],
          ),
      ],
    );
  }
}
