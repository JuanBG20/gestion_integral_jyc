import 'package:gestion_integral_jyc/features/expenses/data/models/expense_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient supabaseClient;

  ExpenseRemoteDataSource(this.supabaseClient);

  Future<List<ExpenseModel>> fetchExpenses() async {
    final response = await supabaseClient
        .from('gasto')
        .select()
        .order('fecha', ascending: false);

    return (response as List)
        .map((json) => ExpenseModel.fromJson(json))
        .toList();
  }

  Future<ExpenseModel> insertExpense(ExpenseModel expense) async {
    final response = await supabaseClient
        .from('gasto')
        .insert(expense.toJson())
        .select()
        .single();

    return ExpenseModel.fromJson(response);
  }

  Future<void> deleteExpense(int id) async {
    await supabaseClient.from('gasto').delete().eq('idgasto', id);
  }
}
