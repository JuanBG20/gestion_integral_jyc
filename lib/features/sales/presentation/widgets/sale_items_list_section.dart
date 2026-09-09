import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/product_items_list_section.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/services/supabase_scan_listener.dart';

class SaleItemsListSection extends StatefulWidget {
  final ValueChanged<List<SaleItemEntity>> onItemsChanged;

  const SaleItemsListSection({super.key, required this.onItemsChanged});

  @override
  State<SaleItemsListSection> createState() => _SaleItemsListSectionState();
}

class _SaleItemsListSectionState extends State<SaleItemsListSection> {
  late final SupabaseScanListener _scanListener;

  @override
  void initState() {
    super.initState();
    _scanListener = SupabaseScanListener();
  }

  @override
  void dispose() {
    _scanListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductItemsListSection<SaleItemEntity>(
      onItemsChanged: widget.onItemsChanged,
      sectionTitle: "Agregar Producto",
      genericItemLabel: "Producto Genérico",
      genericDescriptionHint: "Soporte para Celular",
      scanListener: _scanListener,
      itemBuilder:
          ({
            required variantProduct,
            required quantity,
            required unitPrice,
            description,
          }) => SaleItemEntity(
            variantProduct: variantProduct,
            quantity: quantity,
            unitPrice: unitPrice,
            description: description,
          ),
    );
  }
}
