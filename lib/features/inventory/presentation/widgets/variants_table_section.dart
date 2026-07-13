import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';

class VariantFormData {
  final int? id;
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
    this.id,
  });
}

class VariantsTableSection extends ConsumerStatefulWidget {
  final List<VariantFormData>? initialVariants;
  final ValueChanged<List<VariantFormData>> onVariantsChanged;

  const VariantsTableSection({
    super.key,
    required this.onVariantsChanged,
    this.initialVariants,
  });

  @override
  ConsumerState<VariantsTableSection> createState() =>
      _VariantsTableSectionState();
}

class _VariantsTableSectionState extends ConsumerState<VariantsTableSection> {
  late List<VariantFormData> _variants;
  final List<MaterialRecipeEntity> _pendingRecipe = [];

  final _skuController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController();
  final _costController = TextEditingController();
  final _saleController = TextEditingController();

  bool _isAddingItem = false;

  @override
  void initState() {
    super.initState();
    _variants = widget.initialVariants != null
        ? List.from(widget.initialVariants!)
        : [];
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

  void _addVariant() {
    if (_skuController.text.trim().isEmpty) return;

    setState(() {
      _variants.add(
        VariantFormData(
          sku: _skuController.text.trim(),
          color: _colorController.text.trim(),
          size: _sizeController.text.trim().isEmpty
              ? '-'
              : _sizeController.text.trim(),
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

  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
      widget.onVariantsChanged(_variants);
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
                        return LabeledDropdown<RawMaterialEntity>(
                          label: "Materia Prima",
                          hint: "Seleccione una materia prima...",
                          value: dialogSelectedMaterial,
                          items: materials
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    m.description,
                                    style: context.textTheme.bodyMedium,
                                  ),
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

                    LabeledTextField(
                      controller: dialogQtyController,
                      label: "Cantidad",
                      hint: "150",
                      inputType: const TextInputType.numberWithOptions(
                        decimal: true,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_variants.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                _buildVariantCard(_variants[index], index),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: _variants.length,
          ),

        const SizedBox(height: 8),

        if (!_isAddingItem) ...[
          InkWell(
            onTap: () => setState(() => _isAddingItem = true),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.onBackground),
                  const SizedBox(width: 8),
                  Text(
                    "Click para agregar otra variante...",
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ] else
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 500;
              final double thirdWidth = isWide
                  ? (constraints.maxWidth - 32) / 3
                  : constraints.maxWidth;

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
                    ],
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: thirdWidth,
                        child: LabeledTextField(
                          controller: _stockController,
                          label: "Stock",
                          hint: "0",
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: thirdWidth,
                        child: LabeledTextField(
                          controller: _costController,
                          label: "Precio Costo (\$)",
                          hint: "0.00",
                          inputType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      SizedBox(
                        width: thirdWidth,
                        child: LabeledTextField(
                          controller: _saleController,
                          label: "Precio Venta (\$)",
                          hint: "0.00",
                          inputType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _openRecipeDialog,
                              label: Text(
                                _pendingRecipe.isEmpty
                                    ? "Definir Receta"
                                    : "Receta (${_pendingRecipe.length})",
                              ),
                              icon: Icon(
                                Icons.science_outlined,
                                color: _pendingRecipe.isNotEmpty
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => setState(() {
                                    _isAddingItem = false;
                                    _pendingRecipe.clear();
                                  }),
                                  label: Text("Cancelar"),
                                  icon: const Icon(Icons.close),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _addVariant();
                                    setState(() {
                                      _isAddingItem = false;
                                    });
                                  },
                                  label: Text("Agregar Variante"),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _openRecipeDialog,
                              label: Text(
                                _pendingRecipe.isEmpty
                                    ? "Definir Receta"
                                    : "Receta (${_pendingRecipe.length})",
                              ),
                              icon: Icon(
                                Icons.science_outlined,
                                color: _pendingRecipe.isNotEmpty
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => setState(() {
                                      _isAddingItem = false;
                                      _pendingRecipe.clear();
                                    }),
                                    label: Text("Cancelar"),
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _addVariant();
                                      setState(() {
                                        _isAddingItem = false;
                                      });
                                    },
                                    label: Text("Agregar Variante"),
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildVariantCard(VariantFormData variant, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variant.sku,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${variant.color.isNotEmpty ? variant.color : "-"} · ${variant.size} · Stock: ${variant.stock}',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${variant.salePrice.toStringAsFixed(2)}",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Costo: \$${variant.costPrice.toStringAsFixed(2)}",
                style: context.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(width: 16),

          Icon(
            Icons.science_outlined,
            color: variant.recipe.isNotEmpty
                ? AppColors.primary
                : AppColors.onBackground,
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed: () => _removeVariant(index),
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Eliminar variante',
          ),
        ],
      ),
    );
  }
}
