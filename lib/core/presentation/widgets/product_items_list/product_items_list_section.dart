import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/product_item_entry_form.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/product_items_list_controller.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/product_line_item_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';

class ProductItemsListSection<T extends ProductLineItemEntity>
    extends ConsumerStatefulWidget {
  final ValueChanged<List<T>> onItemsChanged;
  final ProductLineItemBuilder<T> itemBuilder;
  final String sectionTitle;
  final String genericItemLabel;
  final String genericDescriptionHint;
  final List<T> initialItems;
  final ItemScanListener? scanListener;

  const ProductItemsListSection({
    super.key,
    required this.onItemsChanged,
    required this.itemBuilder,
    this.sectionTitle = "Ítems",
    this.genericItemLabel = "Ítem Genérico",
    this.genericDescriptionHint = "Descripción del ítem",
    this.initialItems = const [],
    this.scanListener,
  });

  @override
  ConsumerState<ProductItemsListSection<T>> createState() =>
      _ProductItemsListSectionState<T>();
}

class _ProductItemsListSectionState<T extends ProductLineItemEntity>
    extends ConsumerState<ProductItemsListSection<T>> {
  late final ProductItemsListController<T> _controller;

  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _qtyFocusNode = FocusNode();

  StreamSubscription<String>? _scanSubscription;

  @override
  void initState() {
    super.initState();

    _controller = ProductItemsListController<T>(
      itemBuilder: widget.itemBuilder,
      initialItems: widget.initialItems,
      onItemsChanged: widget.onItemsChanged,
    )..addListener(_onControllerChanged);

    final scanListener = widget.scanListener;
    if (scanListener != null) {
      _scanSubscription = scanListener.scannedSku.listen(_handleScannedSku);
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

  void _handleScannedSku(String sku) {
    final allVariants = ref.read(flattenedVariantsProvider);
    final matched = _controller.matchScannedSku(sku, allVariants);

    if (matched != null) {
      // Le damos foco a la cantidad para que solo tipeen el número
      _priceController.text = matched.salePrice.toStringAsFixed(2);
      _qtyController.text = '1';
      _qtyFocusNode.requestFocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SKU no encontrado en inventario: $sku')),
      );
    }
  }

  void _onVariantChanged(VariantProductEntity? variant) {
    _controller.selectVariant(variant);
    if (variant != null) {
      _priceController.text = variant.salePrice.toStringAsFixed(2);
    }
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
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;

    final added = _controller.addItem(
      quantity: qty,
      unitPrice: price,
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
    final allVariants = ref.watch(flattenedVariantsProvider);

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

            _controller.isGenericItem
                ? TextButton.icon(
                    onPressed: _onSwitchToInventory,
                    label: Text("Del Inventario"),
                    icon: Icon(Icons.inventory_2_outlined),
                  )
                : TextButton.icon(
                    onPressed: _onSwitchToGeneric,
                    label: Text("Genérico"),
                    icon: Icon(Icons.add_circle_outline),
                  ),
          ],
        ),

        Divider(color: AppColors.outline),

        if (_controller.items.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ProductLineItemCard<T>(
              item: _controller.items[index],
              genericItemLabel: widget.genericItemLabel,
              onDelete: () => _controller.removeItem(index),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: _controller.items.length,
          ),

        const SizedBox(height: 8),

        ProductItemEntryForm(
          isAddingItem: _controller.isAddingItem,
          isGenericItem: _controller.isGenericItem,
          genericDescriptionHint: widget.genericDescriptionHint,
          availableVariants: allVariants,
          selectedVariant: _controller.selectedVariant,
          qtyController: _qtyController,
          priceController: _priceController,
          descController: _descController,
          qtyFocusNode: _qtyFocusNode,
          onVariantChanged: _onVariantChanged,
          onStartAdding: _controller.startAdding,
          onCancel: _onCancel,
          onSubmit: _onSubmit,
        ),
      ],
    );
  }
}
