import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

class RawMaterialsTab extends ConsumerWidget {
  final bool isAdmin;

  const RawMaterialsTab({super.key, required this.isAdmin});

  static const _rawMaterialColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Stock Mínimo", flex: 2),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final rawMaterialsState = ref.watch(rawMaterialProvider);

    return rawMaterialsState.when(
      data: (rawMaterials) {
        if (rawMaterials.isEmpty) {
          return const Center(child: Text("No hay materia primar registrada."));
        }

        final filteredRawMaterials = rawMaterials.where((rm) {
          final descriptionMatch = rm.description.toLowerCase().contains(
            searchQuery,
          );
          final categoryMatch = rm.category.toLowerCase().contains(searchQuery);
          final subcategoryMatch = rm.subcategory.toLowerCase().contains(
            searchQuery,
          );
          final skuMatch = rm.sku.toLowerCase().contains(searchQuery);

          return descriptionMatch ||
              categoryMatch ||
              subcategoryMatch ||
              skuMatch;
        }).toList();

        if (filteredRawMaterials.isEmpty) {
          return const Center(
            child: Text("No se encontraron materias primas."),
          );
        }

        return AppTableShell(
          header: const AppTableHeader(columns: _rawMaterialColumns),
          rows: filteredRawMaterials
              .map(
                (mp) => AppTableRow(
                  trailingWidth: 40,
                  trailing: AppActionMenu(
                    items: [
                      const AppActionMenuItem(
                        value: 'update',
                        label: 'Ajustar Stock',
                      ),
                      const AppActionMenuItem(value: 'edit', label: 'Editar'),
                      if (isAdmin)
                        const AppActionMenuItem(
                          value: 'delete',
                          label: 'Eliminar',
                          isDestructive: true,
                        ),
                    ],
                    onSelected: (value) =>
                        _handleRawMaterialAction(context, ref, mp, value),
                  ),

                  cells: [
                    AppTableCell.text(mp.sku, flex: 2),
                    AppTableCell.text(mp.description, flex: 3),
                    AppTableCell.text(mp.formattedStock, flex: 1),
                    AppTableCell.text(mp.formattedMinStock, flex: 2),
                    AppTableCell.text(mp.fullCategory, flex: 3),
                  ],
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }

  void _handleRawMaterialAction(
    BuildContext context,
    WidgetRef ref,
    RawMaterialEntity material,
    String action,
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
          ref
              .read(rawMaterialProvider.notifier)
              .removeRawMaterial(material.id!);
        }
    }
  }
}
