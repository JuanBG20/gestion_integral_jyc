import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) async {
    final model = ExpenseModel(
      description: expense.description,
      category: expense.category,
      amount: expense.amount,
      date: expense.date,
      isRecurring: expense.isRecurring,
    );
    return await remoteDataSource.insertExpense(model);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await remoteDataSource.deleteExpense(id);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses({
    DateTime? from,
    DateTime? to,
  }) async {
    return await remoteDataSource.fetchExpenses();
  }
}
