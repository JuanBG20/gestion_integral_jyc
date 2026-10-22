import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:go_router/go_router.dart';

class ExpenseTemplatesTab extends ConsumerWidget {
  final bool isAdmin;
  final List<ExpenseTemplateEntity> templates;

  const ExpenseTemplatesTab({
    super.key,
    required this.isAdmin,
    required this.templates,
  });

  static const _templateColumns = [
    AppTableColumn(label: "Activo", flex: 1),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Categoría", flex: 2),
    AppTableColumn(label: "Frecuencia / Día", flex: 2),
    AppTableColumn(label: "Tipo / Monto", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTableShell(
      header: const AppTableHeader(columns: _templateColumns),
      rows: templates.map((template) {
        final frequency =
            template.frequency.name[0].toUpperCase() +
            template.frequency.name.substring(1).toLowerCase();
        final isFixedAmount = template.amountType.name.toLowerCase() == 'fijo';

        return AppTableRow(
          trailingWidth: 40,
          trailing: AppActionMenu(
            items: const [AppActionMenuItem(value: 'edit', label: 'Editar')],
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/expenses/edit-template', extra: template);
              }
            },
          ),
          cells: [
            AppTableCell(
              flex: 1,
              child: Switch(
                value: template.isActive,
                onChanged: isAdmin
                    ? (value) {
                        if (template.id != null) {
                          ref
                              .read(expenseTemplateProvider.notifier)
                              .toggleTemplateStatus(template.id!, value);
                        }
                      }
                    : null,
                activeThumbColor: AppColors.primary,
              ),
            ),
            AppTableCell.text(template.description, flex: 3),
            AppTableCell.text(template.category.name, flex: 2),
            AppTableCell.text('$frequency (Día ${template.dueDay})', flex: 2),
            AppTableCell.text(
              isFixedAmount
                  ? 'Fijo: \$${template.amount?.toStringAsFixed(2) ?? '0.00'}'
                  : 'Variable',
              flex: 2,
            ),
          ],
        );
      }).toList(),
    );
  }
}
