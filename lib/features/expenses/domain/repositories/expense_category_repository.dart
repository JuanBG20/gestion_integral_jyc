import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';

abstract class ExpenseCategoryRepository {
  Future<List<ExpenseCategoryEntity>> getCategories();
  Future<void> createCategory(ExpenseCategoryEntity category);
}
