import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';

typedef ProductLineItemBuilder<T extends ProductLineItemEntity> =
    T Function({
      required VariantProductEntity? variantProduct,
      required int quantity,
      required double unitPrice,
      String? description,
    });

class ProductItemsListSection<T extends ProductLineItemEntity>
    extends ConsumerStatefulWidget {
  final ValueChanged<List<T>> onItemsChanged;
  final ProductLineItemBuilder<T> itemBuilder;
  final String sectionTitle;
  final String genericItemLabel;
  final String genericDescriptionHint;
  final List<T> initialItems;

  const ProductItemsListSection({
    super.key,
    required this.onItemsChanged,
    required this.itemBuilder,
    this.sectionTitle = "Ítems",
    this.genericItemLabel = "Ítem Genérico",
    this.genericDescriptionHint = "Descripción del ítem",
    this.initialItems = const [],
  });

  @override
  ConsumerState<ProductItemsListSection<T>> createState() =>
      _ProductItemsListSectionState<T>();
}

class _ProductItemsListSectionState<T extends ProductLineItemEntity>
    extends ConsumerState<ProductItemsListSection<T>> {
  late List<T> _items;

  VariantProductEntity? _selectedVariant;
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  bool _isGenericItem = false;
  bool _isAddingItem = false;

  @override
  void initState() {
    super.initState();
    _items = List<T>.from(widget.initialItems);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addItem() {
    final int qty = int.tryParse(_qtyController.text) ?? 0;
    final double price =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
    final String desc = _descController.text.trim();

    if (qty <= 0) return;
    if (!_isGenericItem && _selectedVariant == null) return;
    if (_isGenericItem && desc.isEmpty) {
      return; // Si es genérico, debe tener descripción
    }

    setState(() {
      _items.add(
        widget.itemBuilder(
          variantProduct: _isGenericItem ? null : _selectedVariant,
          quantity: qty,
          unitPrice: price,
          description: _isGenericItem ? desc : null,
        ),
      );

      // Notificar a la pantalla principal
      widget.onItemsChanged(_items);

      // Limpiar formulario
      _selectedVariant = null;
      _qtyController.text = '1';
      _priceController.clear();
      _descController.clear();
      _isGenericItem = false;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      widget.onItemsChanged(_items);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryProductsProvider);

    final List<VariantProductEntity> allVariants = [];
    if (inventoryState is AsyncData) {
      for (var group in inventoryState.value!) {
        allVariants.addAll(group.variants);
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(widget.sectionTitle, style: context.textTheme.titleMedium),

            _isGenericItem
                ? TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isGenericItem = false;
                        _descController.clear();
                        _priceController.clear();
                      });
                    },
                    label: Text("Producto del Inventario"),
                    icon: Icon(Icons.inventory_2_outlined),
                  )
                : TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isGenericItem = true;
                        _selectedVariant = null;
                        _priceController.clear();
                      });
                    },
                    label: Text("Producto Genérico"),
                    icon: Icon(Icons.add_circle_outline),
                  ),
          ],
        ),

        Divider(color: AppColors.outline),

        if (_items.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildItemCard(_items[index], index);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: _items.length,
          ),

        const SizedBox(height: 8),

        if (!_isAddingItem) ...[
          InkWell(
            onTap: () => setState(() {
              _isAddingItem = true;
            }),
            borderRadius: BorderRadius.circular(4),

            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                // TODO: Dotted border
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(4),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Icon(Icons.add, color: AppColors.onBackground),

                  const SizedBox(width: 8),

                  Text(
                    "Click para agregar otro ítem...",
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ] else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _isGenericItem
                        ? LabeledTextField(
                            controller: _descController,
                            label: "Descripción",
                            hint: widget.genericDescriptionHint,
                          )
                        : LabeledDropdown(
                            value: _selectedVariant,
                            label: "Producto",
                            hint: "Seleccione un producto...",
                            items: allVariants.map((v) {
                              final title =
                                  '${v.baseProduct.description} ${v.color ?? ''} ${v.size ?? ''}'
                                      .trim();
                              return DropdownMenuItem(
                                value: v,
                                child: Text(
                                  '$title (${v.sku})',
                                  style: context.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedVariant = val;
                                if (val != null) {
                                  _priceController.text = val.salePrice
                                      .toStringAsFixed(2);
                                }
                              });
                            },
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Cantidad
                  Expanded(
                    flex: 1,
                    child: LabeledTextField(
                      controller: _qtyController,
                      label: "Cant.",
                      hint: "0",
                      inputType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Precio Unitario
                  Expanded(
                    flex: 2,
                    child: LabeledTextField(
                      controller: _priceController,
                      label: "Precio Un. (\$)",
                      hint: "1000",
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _isAddingItem = false;
                      _isGenericItem = false;
                    }),
                    label: Text("Cancelar"),
                    icon: const Icon(Icons.close),
                  ),

                  const SizedBox(width: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      _addItem();
                      setState(() {
                        _isAddingItem = false;
                        _isGenericItem = false;
                      });
                    },
                    label: Text("Agregar"),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildItemCard(T item, int index) {
    final itemName = item.variantProduct != null
        ? '${item.variantProduct!.baseProduct.description} ${item.variantProduct!.color ?? ''}'
              .trim()
        : item.description ?? widget.genericItemLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),

            child: Text(
              '${item.quantity}x',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  itemName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.variantProduct?.sku != null)
                  Text(
                    item.variantProduct!.sku,
                    style: context.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            "\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}",
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 16),

          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Eliminar ítem',
          ),
        ],
      ),
    );
  }
}
