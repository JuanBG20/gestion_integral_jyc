import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

void handleRawMaterialSharedAction(
  BuildContext context,
  WidgetRef ref,
  RawMaterialEntity material,
  String action,
  bool isAdmin,
) {
  switch (action) {
    case 'update':
      showStockDialog(
        context: context,
        title: 'Actualizar Stock: ${material.description}',
        isProduct: false,
        isAdmin: isAdmin,
        onConfirm: (delta, _) {
          if (material.id != null) {
            ref
                .read(rawMaterialProvider.notifier)
                .updateStock(material.id!, delta);
          }
        },
      );
    case 'edit':
      context.go('/inventory/edit-material', extra: material);
    case 'delete':
      if (material.id != null) {
        ref.read(rawMaterialProvider.notifier).removeRawMaterial(material.id!);
      }
  }
}
