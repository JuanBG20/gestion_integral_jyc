import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/utils/expense_action_handler.dart';

class ExpensesHistoryTab extends ConsumerWidget {
  final bool isAdmin;
  final List<ExpenseEntity> expenses;

  const ExpensesHistoryTab({
    super.key,
    required this.isAdmin,
    required this.expenses,
  });

  static const _expenseColumns = [
    AppTableColumn(label: "Fecha", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Categoría", flex: 2),
    AppTableColumn(label: "Monto", flex: 2),
    AppTableColumn(label: "Estado", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTableShell(
      header: const AppTableHeader(columns: _expenseColumns),
      rows: expenses
          .map(
            (expense) => AppTableRow(
              trailingWidth: 40,
              trailing: AppActionMenu(
                items: [
                  const AppActionMenuItem(
                    value: 'details',
                    label: 'Ver Detalle',
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
                    handleExpenseSharedAction(context, ref, expense, value),
              ),
              cells: [
                AppTableCell.text(expense.emissionDate.ddMMyyyy, flex: 2),
                AppTableCell.text(expense.description, flex: 3),
                AppTableCell.text(expense.category.name, flex: 2),
                AppTableCell.text(
                  '\$${expense.amount?.toStringAsFixed(2) ?? '0.00'}',
                  flex: 2,
                ),
                AppTableCell.text(
                  expense.paymentStatus.dbValue,
                  flex: 2,
                  style: expense.paymentStatus == ExpensePaymentStatus.pendiente
                      ? TextStyle(color: AppColors.error)
                      : null,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
