import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AllWorksScreen extends ConsumerWidget {
  const AllWorksScreen({super.key});

  static const _workColumns = [
    AppTableColumn(label: "ID", flex: 2),
    AppTableColumn(label: "Cliente", flex: 3),
    AppTableColumn(label: "Estado", flex: 2),
    AppTableColumn(label: "F. Creación", flex: 2),
    AppTableColumn(label: "F. Límite", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Órdenes de Trabajo",
                      style: context.textTheme.titleLarge,
                    ),
                    Text(
                      "Gestión de trabajos en proceso.",
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: () => context.go('/work/new'),
                  label: Text("Nuevo Trabajo"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 24),

            worksState.when(
              data: (works) {
                if (works.isEmpty) {
                  return const Center(
                    child: Text("No hay trabajos registrados."),
                  );
                }

                return AppTableShell(
                  shrinkWrap: true,
                  header: const AppTableHeader(columns: _workColumns),
                  rows: works
                      .map(
                        (w) => AppTableRow(
                          trailingWidth: 40,
                          trailing: _buildActionMenu(context, work: w),

                          cells: [
                            AppTableCell.text('TRB-${w.id ?? ''}', flex: 2),
                            AppTableCell.text(w.client.fullName, flex: 3),
                            AppTableCell.text(w.actualState.dbValue, flex: 2),
                            AppTableCell.text(
                              DateFormat('dd/MM/yyyy').format(w.creationDate),
                              flex: 2,
                            ),
                            AppTableCell.text(
                              w.deadline != null
                                  ? DateFormat('dd/MM/yyyy').format(w.deadline!)
                                  : '-',
                              flex: 2,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text("Error: $e")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, {required WorkEntity work}) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {
        if (value == 'details') {
          context.go('/work/detail', extra: work);
        }
        if (value == 'edit') {
          context.go('/work/edit', extra: work);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'details', child: Text('Ver Detalle')),
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
      ],
    );
  }
}
