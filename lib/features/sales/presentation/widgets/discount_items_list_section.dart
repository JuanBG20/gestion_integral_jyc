import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/discount_origin.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_item_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';

class DiscountItemsListSection extends StatefulWidget {
  final double currentSubtotal;
  final ValueChanged<List<DiscountEntity>> onItemsChanged;

  const DiscountItemsListSection({
    super.key,
    required this.currentSubtotal,
    required this.onItemsChanged,
  });

  @override
  State<DiscountItemsListSection> createState() =>
      _DiscountItemsListSectionState();
}

class _DiscountItemsListSectionState extends State<DiscountItemsListSection> {
  final List<DiscountEntity> _items = [];
  bool _isAddingItem = false;

  final _reasonController = TextEditingController();
  final _amountController = TextEditingController();
  final _focusNode = FocusNode();

  DiscountOrigin _selectedOrigin = DiscountOrigin.otro;
  bool _isPercentage = true;

  @override
  void dispose() {
    _reasonController.dispose();
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startAdding() {
    setState(() => _isAddingItem = true);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  void _cancelAdding() {
    setState(() {
      _isAddingItem = false;
      _reasonController.clear();
      _amountController.clear();
      _selectedOrigin = DiscountOrigin.otro;
    });
  }

  void _onSubmit() {
    final reason = _reasonController.text.trim();
    final value =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    if (reason.isEmpty || value <= 0) return;

    double amount;
    double? percentage;

    if (_isPercentage) {
      if (widget.currentSubtotal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agregue productos antes de aplicar %")),
        );

        return;
      }

      percentage = value;
      amount = (widget.currentSubtotal * value) / 100;
    } else {
      amount = value;
    }

    setState(() {
      _items.add(
        DiscountEntity(
          reason: reason,
          amount: amount,
          origin: _selectedOrigin,
          percentage: percentage,
        ),
      );
    });

    widget.onItemsChanged(_items);
    _cancelAdding();
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
    widget.onItemsChanged(_items);
  }

  void _toggleDiscountType() {
    setState(() {
      _isPercentage = !_isPercentage;
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Text(
                "Agregar Descuento",
                style: context.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            TextButton.icon(
              onPressed: _toggleDiscountType,
              label: Text(_isPercentage ? "Monto" : "Porcentaje"),
              icon: Icon(_isPercentage ? Icons.attach_money : Icons.percent),
            ),
          ],
        ),

        Divider(color: AppColors.outline),

        if (_items.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _items[index];

              return LineItemCard(
                leadingText: item.percentage != null ? "%" : "\$",
                title: item.displayReason,
                subtitle: item.origin.label,
                amountText: "-\$${item.amount.toStringAsFixed(2)}",
                onDelete: () => _removeItem(index),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemCount: _items.length,
          ),

        const SizedBox(height: 8),

        if (!_isAddingItem)
          InkWell(
            onTap: _startAdding,
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
                      "Click para agregar un descuento...",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: LabeledTextField(
                      controller: _reasonController,
                      focusNode: _focusNode,
                      label: "Motivo",
                      hint: "Promo / Evento...",
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    flex: 2,
                    child: LabeledDropdown<DiscountOrigin>(
                      label: "Origen",
                      value: _selectedOrigin,
                      items: DiscountOrigin.values
                          .where((e) => e != DiscountOrigin.metodoPago)
                          .map(
                            (o) => DropdownMenuItem(
                              value: o,
                              child: Text(o.label),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedOrigin = val);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              LabeledTextField(
                controller: _amountController,
                label: _isPercentage ? "Porcentaje (%)" : "Monto (\$)",
                hint: "0",
                inputType: const TextInputType.numberWithOptions(decimal: true),
              ),

              const SizedBox(height: 16),

              if (context.isMobileLayout) ...[
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _cancelAdding,
                        label: const Text("Cancelar"),
                        icon: const Icon(Icons.close),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onSubmit,
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
                      onPressed: _cancelAdding,
                      label: const Text("Cancelar"),
                      icon: const Icon(Icons.close),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton.icon(
                      onPressed: _onSubmit,
                      label: const Text("Agregar"),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
