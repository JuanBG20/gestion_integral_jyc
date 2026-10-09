import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_category_model.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_raw_material_model.dart';
import 'package:gestion_integral_jyc/features/expenses/data/models/expense_template_model.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    super.id,
    super.template,
    required super.description,
    required super.category,
    super.amount,
    required super.paymentStatus,
    required super.emissionDate,
    super.paymentDate,
    super.dueDate,
    super.rawMaterialItems,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['idgasto'] as int?,
      template: json['plantilla_gasto'] != null
          ? ExpenseTemplateModel.fromJson(json['plantilla_gasto'])
          : null,
      description: json['descripcion'] as String,
      category: ExpenseCategoryModel.fromJson(json['categoria_gasto']),
      amount: (json['monto'] as num?)?.toDouble(),
      paymentStatus: ExpensePaymentStatus.fromDB(json['estado_pago'] as String),
      emissionDate: DateTime.parse(json['fecha_emision']).toLocal(),
      paymentDate: json['fecha_pago'] != null
          ? DateTime.parse(json['fecha_pago']).toLocal()
          : null,
      dueDate: json['fecha_vencimiento'] != null
          ? DateTime.parse(json['fecha_vencimiento']).toLocal()
          : null,
      rawMaterialItems:
          (json['gasto_materia_prima'] as List<dynamic>?)
              ?.map(
                (item) => ExpenseRawMaterialModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idgasto': id,
      if (template != null) 'plantilla_gasto': template!.id,
      'descripcion': description,
      'categoria_gasto': category.id,
      'monto': amount,
      'estado_pago': paymentStatus.dbValue,
      'fecha_emision': emissionDate.toUtc().toIso8601String(),
      if (paymentDate != null)
        'fecha_pago': paymentDate!.toUtc().toIso8601String(),
      if (dueDate != null)
        'fecha_vencimiento': dueDate!.toUtc().toIso8601String(),
    };
  }
}
