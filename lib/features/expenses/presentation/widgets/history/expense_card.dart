import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/utils/expense_action_handler.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/info_budget.dart';
import 'package:go_router/go_router.dart';

class ExpenseCard extends ConsumerWidget {
  final ExpenseEntity expense;
  final bool isAdmin;

  const ExpenseCard({super.key, required this.expense, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCardShell(
      onTapCard: () => context.push('/expenses/detail', extra: expense),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  InfoBudget(text: expense.category.name),

                  const SizedBox(height: 8),

                  Text(
                    expense.description,
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            AppActionMenu(
              items: [
                const AppActionMenuItem(value: 'details', label: 'Ver Detalle'),
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
          ],
        ),

        const SizedBox(height: 12),
        Divider(color: AppColors.outline),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text("Vencimiento", style: context.textTheme.bodySmall),
                Text(expense.dueDate?.ddMMyyyy ?? "Sin Vencimiento"),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text("Monto", style: context.textTheme.bodySmall),
                Text(
                  '\$${expense.amount?.toStringAsFixed(2) ?? '0.00'}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
