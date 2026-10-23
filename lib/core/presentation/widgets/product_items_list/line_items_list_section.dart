import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_item_entry_form.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/line_items_list_controller.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LineItemsListSection<T, O extends Object> extends StatefulWidget {
  final ValueChanged<List<T>> onItemsChanged;
  final LineItemBuilder<T, O> itemBuilder;

  final List<O> options;
  final String Function(O option) optionItemLabel;
  final String optionLabel;
  final String optionHint;

  final Widget Function(BuildContext context, T item, VoidCallback onDelete)
  itemCardBuilder;

  final String sectionTitle;
  final String genericDescriptionHint;
  final String inventoryButtonLabel;
  final String genericButtonLabel;
  final List<T> initialItems;

  final bool allowGeneric;
  final bool decimalQuantity;

  final double? Function(O option)? defaultPriceOf;
  final double Function(O? option, double quantity, double enteredPrice)?
  unitPriceFromInput;
  final String Function(O? selected)? quantityLabelOf;
  final String Function(O? selected)? priceLabelOf;

  final ItemScanListener? scanListener;
  final String Function(O option)? scanCodeOf;
  final String Function(String code)? scanNotFoundMessage;

  const LineItemsListSection({
    super.key,
    required this.onItemsChanged,
    required this.itemBuilder,
    required this.options,
    required this.optionItemLabel,
    required this.optionLabel,
    required this.optionHint,
    required this.itemCardBuilder,
    this.sectionTitle = "Ítems",
    this.genericDescriptionHint = "Descripción del ítem",
    this.inventoryButtonLabel = "Del Inventario",
    this.genericButtonLabel = "Genérico",
    this.initialItems = const [],
    this.allowGeneric = true,
    this.decimalQuantity = false,
    this.defaultPriceOf,
    this.unitPriceFromInput,
    this.quantityLabelOf,
    this.priceLabelOf,
    this.scanListener,
    this.scanCodeOf,
    this.scanNotFoundMessage,
  });

  @override
  State<LineItemsListSection<T, O>> createState() =>
      _LineItemsListSectionState<T, O>();
}

class _LineItemsListSectionState<T, O extends Object>
    extends State<LineItemsListSection<T, O>> {
  late final LineItemsListController<T, O> _controller;

  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _qtyFocusNode = FocusNode();

  StreamSubscription<String>? _scanSubscription;

  @override
  void initState() {
    super.initState();

    _controller = LineItemsListController<T, O>(
      itemBuilder: widget.itemBuilder,
      initialItems: widget.initialItems,
      onItemsChanged: widget.onItemsChanged,
      allowGeneric: widget.allowGeneric,
    )..addListener(_onControllerChanged);

    final scanListener = widget.scanListener;
    if (scanListener != null && widget.scanCodeOf != null) {
      _scanSubscription = scanListener.scannedSku.listen(_handleScannedCode);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _scanSubscription?.cancel();
    _qtyController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _qtyFocusNode.dispose();

    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _fillDefaultPrice(O option) {
    final price = widget.defaultPriceOf?.call(option);
    if (price != null) _priceController.text = price.toStringAsFixed(2);
  }

  void _handleScannedCode(String code) {
    final matched = _controller.matchScannedCode(
      code,
      widget.options,
      widget.scanCodeOf!,
    );

    if (matched != null) {
      _fillDefaultPrice(matched);
      _qtyController.text = '1';
      _qtyFocusNode.requestFocus();
    } else {
      final message =
          widget.scanNotFoundMessage?.call(code) ??
          'Código no encontrado en inventario: $code';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onOptionChanged(O? option) {
    _controller.selectOption(option);
    if (option != null) _fillDefaultPrice(option);
  }

  void _onSwitchToInventory() {
    _controller.switchToInventory();
    _descController.clear();
    _priceController.clear();
  }

  void _onSwitchToGeneric() {
    _controller.switchToGeneric();
    _priceController.clear();
  }

  void _onSubmit() {
    final qty =
        double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 0.0;
    final enteredPrice =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;

    final unitPrice =
        widget.unitPriceFromInput?.call(
          _controller.selectedOption,
          qty,
          enteredPrice,
        ) ??
        enteredPrice;

    final added = _controller.addItem(
      quantity: qty,
      unitPrice: unitPrice,
      description: _descController.text,
    );

    if (added) {
      _qtyController.text = '1';
      _priceController.clear();
      _descController.clear();
    } else {
      // TODO: Mostrar error
      _controller.cancelAdding();
    }
  }

  void _onCancel() {
    _controller.cancelAdding();
    _qtyController.text = '1';
    _priceController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _controller.selectedOption;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Text(
                widget.sectionTitle,
                style: context.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (widget.allowGeneric)
              _controller.isGenericItem
                  ? TextButton.icon(
                      onPressed: _onSwitchToInventory,
                      label: Text(widget.inventoryButtonLabel),
                      icon: const Icon(Icons.inventory_2_outlined),
                    )
                  : TextButton.icon(
                      onPressed: _onSwitchToGeneric,
                      label: Text(widget.genericButtonLabel),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
          ],
        ),

        Divider(color: AppColors.outline),

        if (_controller.items.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => widget.itemCardBuilder(
              context,
              _controller.items[index],
              () => _controller.removeItem(index),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: _controller.items.length,
          ),

        const SizedBox(height: 8),

        LineItemEntryForm<O>(
          isAddingItem: _controller.isAddingItem,
          isGenericItem: _controller.isGenericItem,
          genericDescriptionHint: widget.genericDescriptionHint,
          optionLabel: widget.optionLabel,
          optionHint: widget.optionHint,
          options: widget.options,
          selectedOption: selected,
          optionItemLabel: widget.optionItemLabel,
          quantityLabel: widget.quantityLabelOf?.call(selected) ?? "Cant.",
          decimalQuantity: widget.decimalQuantity,
          priceLabel: widget.priceLabelOf?.call(selected) ?? "Precio Un. (\$)",
          qtyController: _qtyController,
          priceController: _priceController,
          descController: _descController,
          qtyFocusNode: _qtyFocusNode,
          onOptionChanged: _onOptionChanged,
          onStartAdding: _controller.startAdding,
          onCancel: _onCancel,
          onSubmit: _onSubmit,
        ),
      ],
    );
  }
}
