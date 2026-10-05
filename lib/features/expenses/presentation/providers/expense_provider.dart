import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final expenseDataSourceProvider = Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource(Supabase.instance.client);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.read(expenseDataSourceProvider));
});

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<List<ExpenseEntity>>>((
      ref,
    ) {
      return ExpenseNotifier(ref.read(expenseRepositoryProvider));
    });

class ExpenseNotifier extends StateNotifier<AsyncValue<List<ExpenseEntity>>> {
  final ExpenseRepository repository;

  ExpenseNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      state = const AsyncValue.loading();
      final expenses = await repository.getExpenses();
      state = AsyncValue.data(expenses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      final newExpense = await repository.addExpense(expense);
      if (state is AsyncData) {
        state = AsyncValue.data([newExpense, ...state.value!]);
      }
    } catch (e) {
      throw Exception('Error al registrar el gasto: $e');
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await repository.deleteExpense(id);
      if (state is AsyncData) {
        final currentList = state.value!;
        state = AsyncValue.data(currentList.where((e) => e.id != id).toList());
      }
    } catch (e) {
      throw Exception('Error al eliminar el gasto: $e');
    }
  }
}
