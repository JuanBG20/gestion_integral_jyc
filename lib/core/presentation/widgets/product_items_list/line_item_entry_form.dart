import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_searchable_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LineItemEntryForm<O extends Object> extends StatelessWidget {
  final bool isAddingItem;
  final bool isGenericItem;
  final String genericDescriptionHint;

  final String optionLabel;
  final String optionHint;
  final List<O> options;
  final O? selectedOption;
  final String Function(O option) optionItemLabel;

  final String quantityLabel;
  final bool decimalQuantity;
  final String priceLabel;

  final TextEditingController qtyController;
  final TextEditingController priceController;
  final TextEditingController descController;
  final FocusNode qtyFocusNode;

  final ValueChanged<O?> onOptionChanged;
  final VoidCallback onStartAdding;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const LineItemEntryForm({
    super.key,
    required this.isAddingItem,
    required this.isGenericItem,
    required this.genericDescriptionHint,
    required this.optionLabel,
    required this.optionHint,
    required this.options,
    this.selectedOption,
    required this.optionItemLabel,
    this.quantityLabel = "Cant.",
    this.decimalQuantity = false,
    this.priceLabel = "Precio Un. (\$)",
    required this.qtyController,
    required this.priceController,
    required this.descController,
    required this.qtyFocusNode,
    required this.onOptionChanged,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            : LabeledSearchableDropdown<O>(
                label: optionLabel,
                hint: optionHint,
                value: selectedOption,
                items: options,
                itemLabel: optionItemLabel,
                onChanged: onOptionChanged,
              ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                controller: qtyController,
                focusNode: qtyFocusNode,
                label: quantityLabel,
                hint: "0",
                inputType: decimalQuantity
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: LabeledTextField(
                controller: priceController,
                label: priceLabel,
                hint: "1000",
                inputType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.attach_money),
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
                  label: const Text("Cancelar"),
                  icon: const Icon(Icons.close),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: onSubmit,
                  label: const Text("Agregar"),
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
                label: const Text("Cancelar"),
                icon: const Icon(Icons.close),
              ),

              const SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: onSubmit,
                label: const Text("Agregar"),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
      ],
    );
  }
}
