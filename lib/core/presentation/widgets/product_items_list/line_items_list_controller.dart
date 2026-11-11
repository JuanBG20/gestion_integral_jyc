import 'package:flutter/foundation.dart';

typedef LineItemBuilder<T, O extends Object> =
    T Function({
      required O? option,
      required double quantity,
      required double unitPrice,
      String? description,
    });

class LineItemsListController<T, O extends Object> extends ChangeNotifier {
  final LineItemBuilder<T, O> _itemBuilder;
  final ValueChanged<List<T>> _onItemsChanged;

  final bool allowGeneric;

  List<T> _items;
  bool _isGenericItem = false;
  bool _isAddingItem = false;
  O? _selectedOption;

  LineItemsListController({
    required LineItemBuilder<T, O> itemBuilder,
    required ValueChanged<List<T>> onItemsChanged,
    this.allowGeneric = true,
    List<T> initialItems = const [],
  }) : _itemBuilder = itemBuilder,
       _onItemsChanged = onItemsChanged,
       _items = List<T>.from(initialItems);

  List<T> get items => List.unmodifiable(_items);
  bool get isGenericItem => _isGenericItem;
  bool get isAddingItem => _isAddingItem;
  O? get selectedOption => _selectedOption;

  void startAdding() {
    _isAddingItem = true;
    notifyListeners();
  }

  void cancelAdding() {
    _isAddingItem = false;
    _isGenericItem = false;
    _selectedOption = null;
    notifyListeners();
  }

  void switchToGeneric() {
    if (!allowGeneric) return;
    _isGenericItem = true;
    _selectedOption = null;
    notifyListeners();
  }

  void switchToInventory() {
    _isGenericItem = false;
    notifyListeners();
  }

  void selectOption(O? option) {
    _selectedOption = option;
    notifyListeners();
  }

  void addOrIncrement({
    required O option,
    required double unitPrice,
    required bool Function(T item) isSameOption,
    required T Function(T item) increment,
  }) {
    final index = _items.indexWhere(isSameOption);
    final updated = List<T>.from(_items);

    if (index >= 0) {
      updated[index] = increment(updated[index]);
    } else {
      updated.add(
        _itemBuilder(option: option, quantity: 1, unitPrice: unitPrice),
      );
    }

    _items = updated;
    _onItemsChanged(_items);
    notifyListeners();
  }

  bool addItem({
    required double quantity,
    required double unitPrice,
    String? description,
  }) {
    final desc = description?.trim() ?? '';

    if (quantity <= 0) return false;
    if (!_isGenericItem && _selectedOption == null) return false;
    if (_isGenericItem && desc.isEmpty) {
      return false;
    }

    _items = List<T>.from(_items)
      ..add(
        _itemBuilder(
          option: _isGenericItem ? null : _selectedOption,
          quantity: quantity,
          unitPrice: unitPrice,
          description: _isGenericItem ? desc : null,
        ),
      );

    _selectedOption = null;
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
