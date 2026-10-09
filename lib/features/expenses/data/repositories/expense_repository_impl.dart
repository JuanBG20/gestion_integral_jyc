import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createExpense(ExpenseEntity expense) async {
    final expenseModel = ExpenseModel(
      id: expense.id,
      template: expense.template,
      description: expense.description,
      category: expense.category,
      amount: expense.amount,
      paymentStatus: expense.paymentStatus,
      emissionDate: expense.emissionDate,
      paymentDate: expense.paymentDate,
      dueDate: expense.dueDate,
      rawMaterialItems: expense.rawMaterialItems,
    );

    await remoteDataSource.createExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await remoteDataSource.deleteExpense(id);
  }

  @override
  Future<ExpenseEntity> getExpenseById(int id) async {
    return await remoteDataSource.getExpenseById(id);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpensePaymentStatus? status,
  }) async {
    return await remoteDataSource.getExpenses(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }

  @override
  Future<void> markAsPaid(
    int expenseId, {
    double? finalAmount,
    DateTime? paymentDate,
  }) async {
    await remoteDataSource.markAsPaid(
      expenseId,
      finalAmount: finalAmount,
      paymentDate: paymentDate,
    );
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final expenseModel = ExpenseModel(
      id: expense.id,
      template: expense.template,
      description: expense.description,
      category: expense.category,
      amount: expense.amount,
      paymentStatus: expense.paymentStatus,
      emissionDate: expense.emissionDate,
      paymentDate: expense.paymentDate,
      dueDate: expense.dueDate,
      rawMaterialItems: expense.rawMaterialItems,
    );

    await remoteDataSource.updateExpense(expenseModel);
  }
}
