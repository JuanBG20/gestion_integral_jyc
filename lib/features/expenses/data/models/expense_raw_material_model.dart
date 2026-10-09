import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/raw_material_model.dart';

class ExpenseRawMaterialModel extends ExpenseRawMaterialEntity {
  ExpenseRawMaterialModel({
    super.id,
    required super.rawMaterial,
    required super.quantity,
    super.unitPrice,
  });

  factory ExpenseRawMaterialModel.fromJson(Map<String, dynamic> json) {
    return ExpenseRawMaterialModel(
      id: json['idgasto_materia_prima'] as int?,
      rawMaterial: RawMaterialModel.fromJson(json['materia_prima']),
      quantity: (json['cantidad'] as num).toDouble(),
      unitPrice: (json['precio_unitario'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idgasto_materia_prima': id,
      'materia_prima': rawMaterial.id,
      'cantidad': quantity,
      'precio_unitario': unitPrice,
    };
  }
}
