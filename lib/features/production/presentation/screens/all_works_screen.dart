import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/deadline_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/utils/work_actions_extension.dart';

class AllWorksScreen extends ConsumerWidget {
  final List<WorkEntity> works;

  const AllWorksScreen({super.key, required this.works});

  static const _workColumns = [
    AppTableColumn(label: "ID", flex: 2),
    AppTableColumn(label: "Cliente", flex: 3),
    AppTableColumn(label: "Estado", flex: 2),
    AppTableColumn(label: "F. Creación", flex: 2),
    AppTableColumn(label: "F. Límite", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTableShell(
      shrinkWrap: true,
      header: const AppTableHeader(columns: _workColumns),
      rows: works
          .map(
            (w) => AppTableRow(
              trailingWidth: 40,
              trailing: AppActionMenu(
                items: [
                  const AppActionMenuItem(
                    value: 'details',
                    label: 'Ver Detalle',
                  ),
                  const AppActionMenuItem(value: 'edit', label: 'Editar'),
                ],
                onSelected: (value) => context.handleWorkAction(w, value),
              ),

              cells: [
                AppTableCell.text('TRB-${w.id ?? ''}', flex: 2),
                AppTableCell.text(w.client.fullName, flex: 3),
                AppTableCell.text(
                  w.actualState.dbValue,
                  flex: 2,
                  style: w.actualState == WorkState.finalizado
                      ? TextStyle(color: Colors.green[700])
                      : null,
                ),
                AppTableCell.text(w.creationDate.ddMMyyyy, flex: 2),
                AppTableCell.text(
                  w.deadline != null ? w.deadline!.ddMMyyyy : '-',
                  flex: 2,
                  style: w.deadline != null
                      ? TextStyle(color: w.deadline!.deadlineColor)
                      : null,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
