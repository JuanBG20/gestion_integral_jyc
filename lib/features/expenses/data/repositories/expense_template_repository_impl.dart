import 'package:gestion_integral_jyc/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_template_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/repositories/expense_template_repository.dart';

class ExpenseTemplateRepositoryImpl implements ExpenseTemplateRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseTemplateRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTemplate(ExpenseTemplateEntity template) async {
    final templateModel = ExpenseTemplateModel(
      id: template.id,
      category: template.category,
      description: template.description,
      frequency: template.frequency,
      amountType: template.amountType,
      amount: template.amount,
      isActive: template.isActive,
      dueDay: template.dueDay,
    );

    await remoteDataSource.createTemplate(templateModel);
  }

  @override
  Future<List<ExpenseTemplateEntity>> getTemplates({
    bool onlyActive = true,
  }) async {
    return await remoteDataSource.getTemplates(onlyActive: onlyActive);
  }

  @override
  Future<void> toggleTemplateStatus(int templateId, bool isActive) async {
    await remoteDataSource.toggleTemplateStatus(templateId, isActive);
  }

  @override
  Future<void> updateTemplate(ExpenseTemplateEntity template) async {
    final templateModel = ExpenseTemplateModel(
      id: template.id,
      category: template.category,
      description: template.description,
      frequency: template.frequency,
      amountType: template.amountType,
      amount: template.amount,
      isActive: template.isActive,
      dueDay: template.dueDay,
    );

    await remoteDataSource.updateTemplate(templateModel);
  }
}
