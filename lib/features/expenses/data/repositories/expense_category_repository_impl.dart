import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_category_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_category_repository.dart';

class ExpenseCategoryRepositoryImpl implements ExpenseCategoryRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseCategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createCategory(ExpenseCategoryEntity category) async {
    final categoryModel = ExpenseCategoryModel(
      id: category.id,
      name: category.name,
    );

    await remoteDataSource.createCategory(categoryModel);
  }

  @override
  Future<List<ExpenseCategoryEntity>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
