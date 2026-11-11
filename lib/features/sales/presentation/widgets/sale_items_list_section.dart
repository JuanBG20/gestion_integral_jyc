import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';
import 'package:gestion_integral_jyc/core/domain/services/merged_scan_listener.dart';
import 'package:gestion_integral_jyc/core/presentation/services/hardware_scan_listener.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/product_items_list/product_items_list_section.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/services/supabase_scan_listener.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/utils/premium_gate.dart';

class SaleItemsListSection extends ConsumerStatefulWidget {
  final ValueChanged<List<SaleItemEntity>> onItemsChanged;

  const SaleItemsListSection({super.key, required this.onItemsChanged});

  @override
  ConsumerState<SaleItemsListSection> createState() =>
      _SaleItemsListSectionState();
}

class _SaleItemsListSectionState extends ConsumerState<SaleItemsListSection> {
  late final ItemScanListener _scanListener;

  // Para ignorar escaneos cuando la pantalla queda dentro del IndexStack
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scanListener = MergedScanListener([
      SupabaseScanListener(),
      HardwareScanListener(isActive: () => mounted && _isVisible),
    ], accept: _acceptScan);
  }

  bool _acceptScan(ItemScanListener source, String code) {
    if (!mounted || !_isVisible) return false;

    if (source is! HardwareScanListener) return true;

    final isPremium = ref.read(subscriptionProvider).asData?.value ?? false;
    if (isPremium) return true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('El lector de códigos es una función Premium.'),
        action: SnackBarAction(
          label: 'Ver planes',
          onPressed: () {
            if (mounted) PremiumGate.guard(context, ref, () {});
          },
        ),
      ),
    );
    return false;
  }

  @override
  void dispose() {
    _scanListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isVisible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);

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
