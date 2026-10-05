import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    super.id,
    required super.description,
    required super.category,
    required super.amount,
    required super.date,
    super.isRecurring,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['idgasto'],
      description: json['descripcion'],
      category: json['categoria'],
      amount: (json['monto'] as num).toDouble(),
      date: DateTime.parse(json['fecha']),
      isRecurring: json['es_recurrente'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idgasto': id,
      'descripcion': description,
      'categoria': category,
      'monto': amount,
      'fecha': date.toUtc().toIso8601String(),
      'es_recurrente': isRecurring,
    };
  }
}
