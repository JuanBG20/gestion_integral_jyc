import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/scrap_action_handler.dart';

class ScrapsTab extends ConsumerWidget {
  final List<ScrapEntity> scraps;
  final bool isAdmin;

  const ScrapsTab({super.key, required this.isAdmin, required this.scraps});

  static const _scrapColumns = [
    AppTableColumn(label: "Materia Prima", flex: 4),
    AppTableColumn(label: "Ancho", flex: 2),
    AppTableColumn(label: "Alto", flex: 2),
    AppTableColumn(label: "Stock", flex: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTableShell(
      header: const AppTableHeader(columns: _scrapColumns),
      rows: scraps
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
                onSelected: (value) => handleScrapSharedAction(
                  context,
                  ref,
                  scrap,
                  value,
                  isAdmin,
                ),
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
  }
}
