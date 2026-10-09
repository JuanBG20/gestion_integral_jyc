import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';

abstract class ExpenseTemplateRepository {
  Future<void> createTemplate(ExpenseTemplateEntity template);
  Future<List<ExpenseTemplateEntity>> getTemplates({bool onlyActive = true});
  Future<void> updateTemplate(ExpenseTemplateEntity template);
  Future<void> toggleTemplateStatus(int templateId, bool isActive);
}
