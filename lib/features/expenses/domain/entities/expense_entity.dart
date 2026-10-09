import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';

class ExpenseEntity {
  final int? id;
  final ExpenseTemplateEntity? template;
  final String description;
  final ExpenseCategoryEntity category;
  final double? amount;
  final ExpensePaymentStatus paymentStatus;
  final DateTime emissionDate;
  final DateTime? paymentDate;
  final DateTime? dueDate;
  final List<ExpenseRawMaterialEntity> rawMaterialItems;

  ExpenseEntity({
    this.id,
    required this.description,
    required this.category,
    this.amount,
    this.template,
    required this.paymentStatus,
    required this.emissionDate,
    this.paymentDate,
    this.dueDate,
    this.rawMaterialItems = const [],
  });
}
