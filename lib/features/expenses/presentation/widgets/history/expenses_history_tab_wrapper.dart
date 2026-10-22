import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/expense_card.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/expenses_history_tab.dart';

class ExpensesHistoryTabWrapper extends ConsumerWidget {
  final bool isAdmin;

  const ExpensesHistoryTabWrapper({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final expensesState = ref.watch(expenseProvider);

    return expensesState.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(child: Text("No hay gastos registrados."));
        }

        final filteredExpenses = expenses.where((exp) {
          final descMatch = exp.description.toLowerCase().contains(searchQuery);
          final catMatch = exp.category.name.toLowerCase().contains(
            searchQuery,
          );
          return descMatch || catMatch;
        }).toList();

        if (filteredExpenses.isEmpty) {
          return const Center(
            child: Text("No se encontraron gastos con esa búsqueda."),
          );
        }

        return context.isMobileLayout
            ? AppMobileList<ExpenseEntity>(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                items: filteredExpenses,
                itemBuilder: (context, expense) =>
                    ExpenseCard(expense: expense, isAdmin: isAdmin),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: ExpensesHistoryTab(isAdmin: isAdmin, expenses: expenses),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error al cargar gastos: $e")),
    );
  }
}
