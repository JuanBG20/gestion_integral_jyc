import 'package:gestion_integral_jyc/core/enums/expense_amount_types.dart';
import 'package:gestion_integral_jyc/core/enums/expense_frequencies.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';

class ExpenseTemplateEntity {
  final int? id;
  final ExpenseCategoryEntity category;
  final String description;
  final ExpenseFrequencies frequency;
  final ExpenseAmountTypes amountType;
  final double? amount;
  final bool isActive;
  final int dueDay;

  ExpenseTemplateEntity({
    this.id,
    required this.category,
    required this.description,
    required this.frequency,
    required this.amountType,
    this.amount,
    required this.isActive,
    required this.dueDay,
  });
}
