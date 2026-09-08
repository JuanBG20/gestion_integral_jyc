import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/scrap_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

void handleScrapSharedAction(
  BuildContext context,
  WidgetRef ref,
  ScrapEntity scrap,
  String action,
  bool isAdmin,
) {
  switch (action) {
    case 'update':
      showStockDialog(
        context: context,
        title: 'Actualizar Retazo: ${scrap.rawMaterial.description}',
        isProduct: false,
        isAdmin: isAdmin,
        onConfirm: (delta, _) {
          if (scrap.id != null) {
            ref
                .read(scrapProvider.notifier)
                .updateStock(scrap.id!, delta.round());
          }
        },
      );
    case 'edit':
      context.go('/inventory/edit-scrap', extra: scrap);
    case 'delete':
      if (scrap.id != null) {
        ref.read(scrapProvider.notifier).removeScrap(scrap.id!);
      }
  }
}
