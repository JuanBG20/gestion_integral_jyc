import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_category_model.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_model.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_template_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient supabaseClient;

  ExpenseRemoteDataSource(this.supabaseClient);

  // Gastos
  Future<void> createExpense(ExpenseModel expense) async {
    final response = await supabaseClient
        .from('gasto')
        .insert(expense.toJson())
        .select()
        .single();

    final createdExpenseId = response['idgasto'];

    if (expense.rawMaterialItems.isNotEmpty) {
      final itemsToInsert = expense.rawMaterialItems.map((item) {
        return {
          'gasto': createdExpenseId,
          'materia_prima': item.rawMaterial.id,
          'cantidad': item.quantity,
          'precio_unitario': item.unitPrice,
        };
      }).toList();

      await supabaseClient.from('gasto_materia_prima').insert(itemsToInsert);
    }
  }

  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpensePaymentStatus? status,
  }) async {
    var query = supabaseClient.from('gasto').select('''
      *,
      plantilla_gasto(*),
      categoria_gasto(*),
      gasto_materia_prima(*, materia_prima(*))
    ''');

    if (startDate != null) {
      query = query.gte('fecha_emision', startDate.toUtc().toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('fecha_emision', endDate.toUtc().toIso8601String());
    }
    if (status != null) {
      query = query.eq('estado_pago', status.dbValue);
    }

    final response = await query.order('fecha_emision', ascending: false);

    return response.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  Future<ExpenseModel> getExpenseById(int id) async {
    final response = await supabaseClient
        .from('gasto')
        .select('''
      *,
      plantilla_gasto(*),
      categoria_gasto(*),
      gasto_materia_prima(*, materia_prima(*))
    ''')
        .eq('idgasto', id)
        .single();

    return ExpenseModel.fromJson(response);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await supabaseClient
        .from('gasto')
        .update(expense.toJson())
        .eq('idgasto', expense.id!);
  }

  Future<void> deleteExpense(int id) async {
    await supabaseClient.from('gasto').delete().eq('idgasto', id);
  }

  Future<void> markAsPaid(
    int expenseId, {
    double? finalAmount,
    DateTime? paymentDate,
  }) async {
    final updateData = <String, dynamic>{
      'estado_pago': ExpensePaymentStatus.pagado.dbValue,
      'fecha_pago': (paymentDate ?? DateTime.now()).toUtc().toIso8601String(),
    };

    if (finalAmount != null) {
      updateData['monto'] = finalAmount;
    }

    await supabaseClient
        .from('gasto')
        .update(updateData)
        .eq('idgasto', expenseId);
  }

  // Plantillas
  Future<void> createTemplate(ExpenseTemplateModel template) async {
    await supabaseClient.from('plantilla_gasto').insert(template.toJson());
  }

  Future<List<ExpenseTemplateModel>> getTemplates({
    bool onlyActive = true,
  }) async {
    var query = supabaseClient
        .from('plantilla_gasto')
        .select('*, categoria_gasto(*)');

    if (onlyActive) {
      query = query.eq('esta_activo', true);
    }

    final response = await query;
    return response.map((json) => ExpenseTemplateModel.fromJson(json)).toList();
  }

  Future<void> updateTemplate(ExpenseTemplateModel template) async {
    await supabaseClient
        .from('plantilla_gasto')
        .update(template.toJson())
        .eq('idplantilla_gasto', template.id!);
  }

  Future<void> toggleTemplateStatus(int templateId, bool isActive) async {
    await supabaseClient
        .from('plantilla_gasto')
        .update({'esta_activo': isActive})
        .eq('idplantilla_gasto', templateId);
  }

  // Categorias
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final response = await supabaseClient
        .from('categoria_gasto')
        .select()
        .order('nombre', ascending: true);

    return response.map((json) => ExpenseCategoryModel.fromJson(json)).toList();
  }

  Future<void> createCategory(ExpenseCategoryModel category) async {
    await supabaseClient.from('categoria_gasto').insert(category.toJson());
  }
}
