import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/raw_material_action_handler.dart';

class RawMaterialsTab extends ConsumerWidget {
  final bool isAdmin;
  final List<RawMaterialEntity> rawMaterials;

  const RawMaterialsTab({
    super.key,
    required this.isAdmin,
    required this.rawMaterials,
  });

  static const _rawMaterialColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Stock Mínimo", flex: 2),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTableShell(
      header: const AppTableHeader(columns: _rawMaterialColumns),
      rows: rawMaterials
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
                onSelected: (value) => handleRawMaterialSharedAction(
                  context,
                  ref,
                  mp,
                  value,
                  isAdmin,
                ),
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
  }
}
