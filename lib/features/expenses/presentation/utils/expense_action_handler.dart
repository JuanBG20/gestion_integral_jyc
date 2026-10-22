import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:go_router/go_router.dart';

void handleExpenseSharedAction(
  BuildContext context,
  WidgetRef ref,
  ExpenseEntity expense,
  String action,
) {
  switch (action) {
    case 'details':
      context.go('expenses/detail', extra: expense);
      break;
    case 'delete':
      if (expense.id != null) {
        ref.read(expenseProvider.notifier).deleteExpense(expense.id!);
      }
      break;
    case 'edit':
      context.push('/expenses/edit', extra: expense);
      break;
  }
}
