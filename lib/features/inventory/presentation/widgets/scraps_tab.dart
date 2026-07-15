import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/scrap_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/stock_dialog.dart';
import 'package:go_router/go_router.dart';

class ScrapsTab extends ConsumerWidget {
  final bool isAdmin;

  const ScrapsTab({super.key, required this.isAdmin});

  static const _scrapColumns = [
    AppTableColumn(label: "Materia Prima", flex: 4),
    AppTableColumn(label: "Ancho", flex: 2),
    AppTableColumn(label: "Alto", flex: 2),
    AppTableColumn(label: "Stock", flex: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final scrapsState = ref.watch(scrapProvider);

    return scrapsState.when(
      data: (scraps) {
        if (scraps.isEmpty) {
          return const Center(child: Text("No hay retazos registrados."));
        }

        final filteredScraps = scraps.where((scrap) {
          final descriptionMatch = scrap.rawMaterial.description
              .toLowerCase()
              .contains(searchQuery);
          final skuMatch = scrap.rawMaterial.sku.toLowerCase().contains(
            searchQuery,
          );

          return descriptionMatch || skuMatch;
        }).toList();

        if (filteredScraps.isEmpty) {
          return const Center(
            child: Text("No se encontraron materias primas."),
          );
        }

        return AppTableShell(
          header: const AppTableHeader(columns: _scrapColumns),
          rows: filteredScraps
              .map(
                (scrap) => AppTableRow(
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
                        _handleScrapAction(context, ref, scrap, value),
                  ),

                  cells: [
                    AppTableCell.text(scrap.rawMaterial.description, flex: 4),
                    AppTableCell.text(
                      '${scrap.width.toStringAsFixed(1)} cm',
                      flex: 2,
                    ),
                    AppTableCell.text(
                      '${scrap.height.toStringAsFixed(1)} cm',
                      flex: 2,
                    ),
                    AppTableCell.text(scrap.stock.toString(), flex: 1),
                  ],
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error al cargar retazos: $e")),
    );
  }

  void _handleScrapAction(
    BuildContext context,
    WidgetRef ref,
    ScrapEntity scrap,
    String action,
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
      // TODO: Delete Material
    }
  }
}
