import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';

class VariantFormData {
  final String sku;
  final String color;
  final String size;
  final int stock;
  final double costPrice;
  final double salePrice;
  final List<MaterialRecipeEntity> recipe;

  VariantFormData({
    required this.sku,
    required this.color,
    required this.size,
    required this.stock,
    required this.costPrice,
    required this.salePrice,
    required this.recipe,
  });
}

class VariantsTableSection extends ConsumerStatefulWidget {
  final ValueChanged<List<VariantFormData>> onVariantsChanged;

  const VariantsTableSection({super.key, required this.onVariantsChanged});

  @override
  ConsumerState<VariantsTableSection> createState() =>
      _VariantsTableSectionState();
}

class _VariantsTableSectionState extends ConsumerState<VariantsTableSection> {
  final List<VariantFormData> _variants = [];
  List<MaterialRecipeEntity> _pendingRecipe = [];

  final _skuController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController();
  final _costController = TextEditingController();
  final _saleController = TextEditingController();

  static const _columns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Color", flex: 2),
    AppTableColumn(label: "Talle", flex: 2),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
  ];

  void _addVariant() {
    if (_skuController.text.isEmpty) return;

    setState(() {
      _variants.add(
        VariantFormData(
          sku: _skuController.text,
          color: _colorController.text,
          size: _sizeController.text.isEmpty ? '-' : _sizeController.text,
          stock: int.tryParse(_stockController.text) ?? 0,
          costPrice:
              double.tryParse(_costController.text.replaceAll(',', '.')) ?? 0.0,
          salePrice:
              double.tryParse(_saleController.text.replaceAll(',', '.')) ?? 0.0,
          recipe: List.from(_pendingRecipe),
        ),
      );

      widget.onVariantsChanged(_variants);

      _skuController.clear();
      _colorController.clear();
      _sizeController.clear();
      _stockController.clear();
      _costController.clear();
      _saleController.clear();
      _pendingRecipe.clear();
    });
  }

  void _openRecipeDialog() {
    final rawMaterialsState = ref.read(rawMaterialProvider);
    RawMaterialEntity? dialogSelectedMaterial;
    final dialogQtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: Text(
                "Definir Receta de Fabricación",
                style: context.textTheme.titleMedium,
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_pendingRecipe.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _pendingRecipe.length,
                        itemBuilder: (context, index) {
                          final recipeItem = _pendingRecipe[index];
                          return ListTile(
                            dense: true,
                            title: Text(recipeItem.rawMaterial.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${recipeItem.quantity} g/cm²"),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      _pendingRecipe.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(color: AppColors.outline),
                    ],
                    const SizedBox(height: 8),
                    rawMaterialsState.when(
                      data: (materials) {
                        return DropdownButtonFormField<RawMaterialEntity>(
                          initialValue: dialogSelectedMaterial,
                          decoration: const InputDecoration(
                            labelText: 'Materia Prima',
                          ),
                          items: materials
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m.description),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setDialogState(
                            () => dialogSelectedMaterial = val,
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dialogQtyController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Cantidad (Ej: 15.5)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (dialogSelectedMaterial == null) return;
                        final qty =
                            double.tryParse(
                              dialogQtyController.text.replaceAll(',', '.'),
                            ) ??
                            0;
                        if (qty <= 0) return;

                        setDialogState(() {
                          _pendingRecipe.add(
                            MaterialRecipeEntity(
                              rawMaterial: dialogSelectedMaterial!,
                              quantity: qty,
                            ),
                          );
                          dialogSelectedMaterial = null;
                          dialogQtyController.clear();
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Agregar a receta"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {}); // Refrescar el ícono de la tabla principal
                  },
                  child: const Text('Listo'),
                ),
              ],
            );
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return AppTableShell(
      shrinkWrap: true,
      header: const AppTableHeader(columns: _columns),
      rows: [
        ..._variants.map(
          (variant) => AppTableRow(
            trailingWidth: 60,
            cells: [
              AppTableCell.text(variant.sku, flex: 2),
              AppTableCell.text(variant.color, flex: 2),
              AppTableCell.text(variant.size, flex: 2),
              AppTableCell.text(variant.stock.toString(), flex: 1),
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
        ),

        AppTableRow(
          showBottomBorder: false,
          trailingWidth: 80,
          cells: [
            AppTableCell.field(
              flex: 2,
              controller: _skuController,
              hint: "PR-001-BCO",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _colorController,
              hint: "Blanco",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _sizeController,
              hint: "40x40cm",
            ),
            AppTableCell.field(
              flex: 1,
              controller: _stockController,
              hint: "0",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _costController,
              hint: "0.00",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _saleController,
              hint: "0.00",
            ),
          ],
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.science_outlined,
                  color: _pendingRecipe.isNotEmpty
                      ? AppColors.primary
                      : AppColors.onBackground,
                ),
                tooltip: 'Definir Receta',
                onPressed: _openRecipeDialog,
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
                tooltip: 'Añadir Variante',
                onPressed: _addVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
