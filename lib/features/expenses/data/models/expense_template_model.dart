import 'package:gestion_integral_jyc/core/enums/expense_amount_types.dart';
import 'package:gestion_integral_jyc/core/enums/expense_frequencies.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_category_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';

class ExpenseTemplateModel extends ExpenseTemplateEntity {
  ExpenseTemplateModel({
    super.id,
    required super.category,
    required super.description,
    required super.frequency,
    required super.amountType,
    super.amount,
    required super.isActive,
    required super.dueDay,
  });

  factory ExpenseTemplateModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTemplateModel(
      id: json['idplantilla_gasto'] as int?,
      category: ExpenseCategoryModel.fromJson(json['categoria_gasto']),
      description: json['descripcion'] as String,
      frequency: ExpenseFrequencies.fromDB(json['frecuencia'] as String),
      amountType: ExpenseAmountTypes.fromDB(json['tipo_monto'] as String),
      amount: (json['monto'] as num?)?.toDouble(),
      isActive: json['esta_activo'] as bool,
      dueDay: json['dia_vencimiento'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idplantilla_gasto': id,
      'categoria_gasto': category.id,
      'descripcion': description,
      'frecuencia': frequency.dbValue,
      'tipo_monto': amountType.dbValue,
      'monto': amount,
      'esta_activo': isActive,
      'dia_vencimiento': dueDay,
    };
  }
}
