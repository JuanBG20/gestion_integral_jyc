import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses({DateTime? from, DateTime? to});
  Future<ExpenseEntity> addExpense(ExpenseEntity expense);
  Future<void> deleteExpense(int id);
}
