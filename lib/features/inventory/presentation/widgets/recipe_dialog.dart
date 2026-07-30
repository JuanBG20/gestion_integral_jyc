import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_searchable_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';

class RecipeDialog extends ConsumerStatefulWidget {
  final List<MaterialRecipeEntity> initialRecipe;

  const RecipeDialog({super.key, required this.initialRecipe});

  @override
  ConsumerState<RecipeDialog> createState() => _RecipeDialogState();
}

class _RecipeDialogState extends ConsumerState<RecipeDialog> {
  late List<MaterialRecipeEntity> _pendingRecipe;
  final _qtyController = TextEditingController();
  RawMaterialEntity? _selectedMaterial;

  @override
  void initState() {
    super.initState();
    _pendingRecipe = List.from(widget.initialRecipe);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void _addMaterial() {
    if (_selectedMaterial == null) return;
    final qty = double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 0;
    if (qty <= 0) return;

    setState(() {
      _pendingRecipe.add(
        MaterialRecipeEntity(rawMaterial: _selectedMaterial!, quantity: qty),
      );
      _selectedMaterial = null;
      _qtyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsState = ref.watch(rawMaterialProvider);

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
                            setState(() {
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
                return LabeledSearchableDropdown<RawMaterialEntity>(
                  label: "Materia Prima",
                  hint: "Seleccione una materia prima...",
                  value: _selectedMaterial,
                  items: materials,
                  itemLabel: (m) => m.description,
                  onChanged: (val) => setState(() => _selectedMaterial = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),

            const SizedBox(height: 16),

            LabeledTextField(
              controller: _qtyController,
              label: "Cantidad",
              hint: "150",
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _addMaterial,
              icon: const Icon(Icons.add),
              label: const Text("Agregar a receta"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _pendingRecipe),
          child: const Text('Listo'),
        ),
      ],
    );
  }
}
