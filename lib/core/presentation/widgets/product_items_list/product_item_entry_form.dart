import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_searchable_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class ProductItemEntryForm extends StatelessWidget {
  final bool isAddingItem;
  final bool isGenericItem;
  final String genericDescriptionHint;

  final List<VariantProductEntity> availableVariants;
  final VariantProductEntity? selectedVariant;

  final TextEditingController qtyController;
  final TextEditingController priceController;
  final TextEditingController descController;
  final FocusNode qtyFocusNode;

  final ValueChanged<VariantProductEntity?> onVariantChanged;
  final VoidCallback onStartAdding;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const ProductItemEntryForm({
    super.key,
    required this.isAddingItem,
    required this.isGenericItem,
    required this.genericDescriptionHint,
    required this.availableVariants,
    this.selectedVariant,
    required this.qtyController,
    required this.priceController,
    required this.descController,
    required this.qtyFocusNode,
    required this.onVariantChanged,
    required this.onStartAdding,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAddingItem) {
      return InkWell(
        onTap: onStartAdding,
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

              Expanded(
                child: Text(
                  "Click para agregar otro ítem...",
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        isGenericItem
            ? LabeledTextField(
                controller: descController,
                label: "Descripción",
                hint: genericDescriptionHint,
              )
            : LabeledSearchableDropdown<VariantProductEntity>(
                label: "Producto",
                hint: "Seleccione un producto...",
                value: selectedVariant,
                items: availableVariants,
                itemLabel: (v) {
                  final title =
                      '${v.baseProduct.description} ${v.color ?? ''} ${v.size ?? ''}'
                          .trim();
                  return '$title (${v.sku})';
                },
                onChanged: onVariantChanged,
              ),

        const SizedBox(height: 16),

        Row(
          children: [
            // Cantidad
            Expanded(
              child: LabeledTextField(
                controller: qtyController,
                focusNode: qtyFocusNode,
                label: "Cant.",
                hint: "0",
                inputType: TextInputType.number,
              ),
            ),

            const SizedBox(width: 16),

            // Precio Unitario
            Expanded(
              child: LabeledTextField(
                controller: priceController,
                label: "Precio Un. (\$)",
                hint: "1000",
                inputType: TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        if (context.isMobileLayout) ...[
          Column(
            children: [
              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  label: Text("Cancelar"),
                  icon: const Icon(Icons.close),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: onSubmit,
                  label: Text("Agregar"),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ] else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              OutlinedButton.icon(
                onPressed: onCancel,
                label: Text("Cancelar"),
                icon: const Icon(Icons.close),
              ),

              const SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: onSubmit,
                label: Text("Agregar"),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
      ],
    );
  }
}
