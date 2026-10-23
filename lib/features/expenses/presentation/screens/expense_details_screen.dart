import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/items_card_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/return_screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/summary_products_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/expense_quick_actions.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/expense_summary_item_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/info_budget.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  final ExpenseEntity initialExpense;

  const ExpenseDetailsScreen({super.key, required this.initialExpense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseProvider);
    final expense = expenseState.maybeWhen(
      data: (expenses) {
        final matches = expenses.where((e) => e.id == initialExpense.id);
        return matches.isNotEmpty ? matches.first : initialExpense;
      },
      orElse: () => initialExpense,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            ReturnScreenHeader(
              title: "Gasto GTO-${expense.id ?? '---'}",
              subtitle:
                  "Registrada el ${expense.emissionDate.ddMMyyyy} - ${expense.emissionDate.hour}:${expense.emissionDate.minute} hrs",
              returnLabel: "Volver a Gastos",
              returnUri: "/expenses",
            ),

            const SizedBox(height: 32),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.isDesktopLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLeftColumn(context, expense),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRightColumn(context, ref, expense),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context, expense),
                      const SizedBox(height: 24),
                      _buildRightColumn(context, ref, expense),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, ExpenseEntity expense) {
    return Column(
      children: [
        _buildInfoHeader(context, expense),

        if (expense.rawMaterialItems.isNotEmpty) ...[
          const SizedBox(height: 16),

          ItemsCardLayout(
            itemCount: expense.rawMaterialItems.length,
            itemsSubtitle: '${expense.rawMaterialItems.length} insumos',
            itemBuilder: (BuildContext context, int index) =>
                ExpenseSummaryItemCard(item: expense.rawMaterialItems[index]),
          ),
        ],
      ],
    );
  }

  Widget _buildRightColumn(
    BuildContext context,
    WidgetRef ref,
    ExpenseEntity expense,
  ) {
    final isPaid = expense.paymentStatus == ExpensePaymentStatus.pagado;

    return Column(
      children: [
        SummaryProductsCard(
          totalAmount: expense.amount ?? 0,
          totalPaid: 0,
          totalOutstanding: expense.amount ?? 0,
          subtotal: expense.amount ?? 0,
        ),

        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Estado del Pago", style: context.textTheme.bodyMedium),
              Text(
                expense.paymentStatus.dbValue,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ExpenseQuickActions(expense: expense, isPaid: isPaid),
      ],
    );
  }

  Widget _buildInfoHeader(BuildContext context, ExpenseEntity expense) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              InfoBudget(text: expense.category.name),

              if (expense.template != null) ...[
                const SizedBox(width: 8),

                InfoBudget(
                  text: "Generado por Plantilla",
                  color: Colors.purple,
                  icon: Icons.autorenew,
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          Text(expense.description, style: context.textTheme.titleLarge),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 1;
              if (constraints.maxWidth > 650) {
                columns = 3;
              } else if (constraints.maxWidth > 450) {
                columns = 2;
              }

              final double fieldWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (24 * (columns - 1))) / columns;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _buildDateDetail(
                      context,
                      "Fecha de Emisión",
                      expense.emissionDate.ddMMyyyy,
                      Icons.calendar_today_outlined,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _buildDateDetail(
                      context,
                      "Fecha de Vencimiento",
                      expense.dueDate?.ddMMyyyy ?? 'Sin vencimiento',
                      Icons.event_busy_outlined,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _buildDateDetail(
                      context,
                      "Fecha de Pago",
                      expense.paymentDate?.ddMMyyyy ?? 'Pendiente',
                      Icons.check_circle_outline,
                      color: expense.paymentDate != null
                          ? AppColors.primary
                          : AppColors.onBackground.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateDetail(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? AppColors.onBackground.withValues(alpha: 0.6),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(label, style: context.textTheme.bodySmall),

            const SizedBox(height: 4),

            Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
