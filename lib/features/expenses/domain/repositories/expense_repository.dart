import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpensePaymentStatus? status,
  });
  Future<ExpenseEntity> getExpenseById(int id);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> createExpense(ExpenseEntity expense);
  Future<void> deleteExpense(int id);
  Future<void> markAsPaid(
    int expenseId, {
    double? finalAmount,
    DateTime? paymentDate,
  });
}
