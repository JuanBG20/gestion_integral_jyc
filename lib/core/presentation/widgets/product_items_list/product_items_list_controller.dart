import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

typedef ProductLineItemBuilder<T extends ProductLineItemEntity> =
    T Function({
      required VariantProductEntity? variantProduct,
      required int quantity,
      required double unitPrice,
      String? description,
    });

class ProductItemsListController<T extends ProductLineItemEntity>
    extends ChangeNotifier {
  final ProductLineItemBuilder<T> _itemBuilder;
  final ValueChanged<List<T>> _onItemsChanged;

  List<T> _items;
  bool _isGenericItem = false;
  bool _isAddingItem = false;
  VariantProductEntity? _selectedVariant;

  ProductItemsListController({
    required ProductLineItemBuilder<T> itemBuilder,
    required ValueChanged<List<T>> onItemsChanged,
    List<T> initialItems = const [],
  }) : _itemBuilder = itemBuilder,
       _onItemsChanged = onItemsChanged,
       _items = List<T>.from(initialItems);

  List<T> get items => List.unmodifiable(_items);
  bool get isGenericItem => _isGenericItem;
  bool get isAddingItem => _isAddingItem;
  VariantProductEntity? get selectedVariant => _selectedVariant;

  void startAdding() {
    _isAddingItem = true;
    notifyListeners();
  }

  void cancelAdding() {
    _isAddingItem = false;
    _isGenericItem = false;
    _selectedVariant = null;
    notifyListeners();
  }

  void switchToGeneric() {
    _isGenericItem = true;
    _selectedVariant = null;
    notifyListeners();
  }

  void switchToInventory() {
    _isGenericItem = false;
    notifyListeners();
  }

  void selectVariant(VariantProductEntity? variant) {
    _selectedVariant = variant;
    notifyListeners();
  }

  VariantProductEntity? matchScannedSku(
    String sku,
    List<VariantProductEntity> availableVariants,
  ) {
    // Buscamos la variante que coincida con el SKU
    final matched = availableVariants.where((v) => v.sku == sku).firstOrNull;

    if (matched != null) {
      _isAddingItem = true;
      _isGenericItem = false;
      _selectedVariant = matched;
      notifyListeners();
    }

    return matched;
  }

  bool addItem({
    required int quantity,
    required double unitPrice,
    String? description,
  }) {
    final desc = description?.trim() ?? '';

    if (quantity <= 0) return false;
    if (!_isGenericItem && _selectedVariant == null) return false;
    if (_isGenericItem && desc.isEmpty) {
      return false; // Si es genérico, debe tener descripción
    }

    _items = List<T>.from(_items)
      ..add(
        _itemBuilder(
          variantProduct: _isGenericItem ? null : _selectedVariant,
          quantity: quantity,
          unitPrice: unitPrice,
          description: _isGenericItem ? desc : null,
        ),
      );

    _selectedVariant = null;
    _isGenericItem = false;
    _isAddingItem = false;

    _onItemsChanged(_items);
    notifyListeners();
    return true;
  }

  void removeItem(int index) {
    _items = List<T>.from(_items)..removeAt(index);
    _onItemsChanged(_items);
    notifyListeners();
  }
}
