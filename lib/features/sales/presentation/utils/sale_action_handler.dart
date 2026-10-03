import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:go_router/go_router.dart';

Future<void> handleSaleSharedAction(
  BuildContext context,
  WidgetRef ref,
  String action,
  SaleEntity sale,
) async {
  switch (action) {
    case 'detail':
      context.push('/sales/detail', extra: sale);
      break;

    case 'bill':
      final isRoot = ref.read(isRootProvider);

      if (!isRoot || !sale.isPaid || sale.isInvoiced) return;

      context.push('/sales/detail/bill', extra: sale);
      break;

    case 'manual_bill':
      if (!sale.isPaid || sale.isInvoiced) return;

      try {
        await ref.read(saleProvider.notifier).markAsManuallyInvoiced(sale.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venta marcada como facturada')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
      break;
  }
}
