import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/repositories/expense_category_repository_impl.dart';
import 'package:gestion_integral_jyc/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:gestion_integral_jyc/features/expenses/data/repositories/expense_template_repository_impl.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_category_repository.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_repository.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_template_repository.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final expenseDataSourceProvider = Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource(Supabase.instance.client);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.read(expenseDataSourceProvider));
});

final expenseCategoryRepositoryProvider = Provider<ExpenseCategoryRepository>((
  ref,
) {
  return ExpenseCategoryRepositoryImpl(ref.read(expenseDataSourceProvider));
});

final expenseTemplateRepositoryProvider = Provider<ExpenseTemplateRepository>((
  ref,
) {
  return ExpenseTemplateRepositoryImpl(ref.read(expenseDataSourceProvider));
});

// --- PROVIDER DE CATEGORÍAS ---

final expenseCategoryProvider =
    StateNotifierProvider<
      ExpenseCategoryNotifier,
      AsyncValue<List<ExpenseCategoryEntity>>
    >((ref) {
      return ExpenseCategoryNotifier(
        ref.read(expenseCategoryRepositoryProvider),
        ref,
      );
    });

class ExpenseCategoryNotifier
    extends StateNotifier<AsyncValue<List<ExpenseCategoryEntity>>> {
  final ExpenseCategoryRepository repository;
  final Ref ref;

  ExpenseCategoryNotifier(this.repository, this.ref)
    : super(const AsyncValue.loading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      state = const AsyncValue.loading();
      final categories = await repository.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCategory(ExpenseCategoryEntity category) async {
    try {
      await repository.createCategory(category);
      await fetchCategories();
    } catch (e) {
      throw Exception('Error al crear la categoría: $e');
    }
  }
}

// --- PROVIDER DE PLANTILLAS ---

final expenseTemplateProvider =
    StateNotifierProvider<
      ExpenseTemplateNotifier,
      AsyncValue<List<ExpenseTemplateEntity>>
    >((ref) {
      return ExpenseTemplateNotifier(
        ref.read(expenseTemplateRepositoryProvider),
        ref,
      );
    });

class ExpenseTemplateNotifier
    extends StateNotifier<AsyncValue<List<ExpenseTemplateEntity>>> {
  final ExpenseTemplateRepository repository;
  final Ref ref;

  ExpenseTemplateNotifier(this.repository, this.ref)
    : super(const AsyncValue.loading()) {
    fetchTemplates();
  }

  Future<void> fetchTemplates({bool onlyActive = true}) async {
    try {
      state = const AsyncValue.loading();
      final templates = await repository.getTemplates(onlyActive: onlyActive);
      state = AsyncValue.data(templates);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createTemplate(ExpenseTemplateEntity template) async {
    try {
      await repository.createTemplate(template);
      await fetchTemplates();
    } catch (e) {
      throw Exception('Error al crear la plantilla: $e');
    }
  }

  Future<void> updateTemplate(ExpenseTemplateEntity template) async {
    try {
      await repository.updateTemplate(template);
      await fetchTemplates();
    } catch (e) {
      throw Exception('Error al actualizar la plantilla: $e');
    }
  }

  Future<void> toggleTemplateStatus(int templateId, bool isActive) async {
    try {
      await repository.toggleTemplateStatus(templateId, isActive);
      await fetchTemplates();
    } catch (e) {
      throw Exception('Error al cambiar el estado de la plantilla: $e');
    }
  }
}

// --- PROVIDER DE GASTOS ---

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<List<ExpenseEntity>>>((
      ref,
    ) {
      return ExpenseNotifier(ref.read(expenseRepositoryProvider), ref);
    });

class ExpenseNotifier extends StateNotifier<AsyncValue<List<ExpenseEntity>>> {
  final ExpenseRepository repository;
  final Ref ref;

  ExpenseNotifier(this.repository, this.ref)
    : super(const AsyncValue.loading()) {
    fetchExpenses();
  }

  Future<void> fetchExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpensePaymentStatus? status,
  }) async {
    try {
      state = const AsyncValue.loading();
      final expenses = await repository.getExpenses(
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
      state = AsyncValue.data(expenses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createExpense(ExpenseEntity expense) async {
    try {
      await repository.createExpense(expense);
      await fetchExpenses();

      if (expense.rawMaterialItems.isNotEmpty) {
        ref.read(rawMaterialProvider.notifier).fetchRawMaterials();
      }
    } catch (e) {
      throw Exception('Error al registrar el gasto: $e');
    }
  }

  Future<void> updateExpense(ExpenseEntity expense) async {
    try {
      await repository.updateExpense(expense);
      await fetchExpenses();
    } catch (e) {
      throw Exception('Error al actualizar el gasto: $e');
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await repository.deleteExpense(id);
      await fetchExpenses();

      ref.read(rawMaterialProvider.notifier).fetchRawMaterials();
    } catch (e) {
      throw Exception('Error al eliminar el gasto: $e');
    }
  }

  Future<void> markAsPaid(
    int expenseId, {
    double? finalAmount,
    DateTime? paymentDate,
  }) async {
    try {
      if (state is AsyncData) {
        final currentExpenses = state.value!;
        final newExpenses = currentExpenses.map((e) {
          if (e.id == expenseId) {
            return ExpenseEntity(
              id: e.id,
              template: e.template,
              description: e.description,
              category: e.category,
              amount: finalAmount ?? e.amount,
              paymentStatus: ExpensePaymentStatus.pagado,
              emissionDate: e.emissionDate,
              paymentDate: paymentDate ?? DateTime.now(),
              dueDate: e.dueDate,
              rawMaterialItems: e.rawMaterialItems,
            );
          }
          return e;
        }).toList();
        state = AsyncValue.data(newExpenses);
      }

      await repository.markAsPaid(
        expenseId,
        finalAmount: finalAmount,
        paymentDate: paymentDate,
      );

      await fetchExpenses();
    } catch (e) {
      await fetchExpenses();
      throw Exception('Error al registrar el pago: $e');
    }
  }
}
