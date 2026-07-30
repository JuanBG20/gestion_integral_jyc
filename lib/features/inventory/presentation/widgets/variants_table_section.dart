import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/variant_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/variant_form_editor.dart';

class VariantFormData {
  final int? id;
  final String sku;
  final String color;
  final String size;
  final int stock;
  final double costPrice;
  final double salePrice;
  final List<MaterialRecipeEntity> recipe;
  final MeasurementUnit measurementUnit;

  VariantFormData({
    required this.sku,
    required this.color,
    required this.size,
    required this.stock,
    required this.costPrice,
    required this.salePrice,
    required this.recipe,
    this.id,
    required this.measurementUnit,
  });
}

class VariantsTableSection extends StatefulWidget {
  final List<VariantFormData>? initialVariants;
  final ValueChanged<List<VariantFormData>> onVariantsChanged;

  const VariantsTableSection({
    super.key,
    required this.onVariantsChanged,
    this.initialVariants,
  });

  @override
  State<VariantsTableSection> createState() => _VariantsTableSectionState();
}

class _VariantsTableSectionState extends State<VariantsTableSection> {
  late List<VariantFormData> _variants;

  bool _isAddingItem = false;

  VariantFormData? _editingVariant;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _variants = widget.initialVariants != null
        ? List.from(widget.initialVariants!)
        : [];
  }

  void _saveVariant(VariantFormData variant) {
    setState(() {
      if (_editingIndex != null) {
        _variants[_editingIndex!] = variant;
      } else {
        _variants.add(variant);
      }

      widget.onVariantsChanged(_variants);

      _closeEditor();
    });
  }

  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
      widget.onVariantsChanged(_variants);
    });
  }

  void _startEdit(int index) {
    setState(() {
      _editingVariant = _variants[index];
      _editingIndex = index;
      _isAddingItem = true;
    });
  }

  void _closeEditor() {
    setState(() {
      _isAddingItem = false;
      _editingVariant = null;
      _editingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_variants.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => VariantCard(
              variant: _variants[index],
              onEdit: _isAddingItem ? null : () => _startEdit(index),
              onDelete: _isAddingItem ? null : () => _removeVariant(index),
            ),
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
          VariantFormEditor(
            initialVariant: _editingVariant,
            onSave: _saveVariant,
            onCancel: _closeEditor,
          ),
      ],
    );
  }
}
