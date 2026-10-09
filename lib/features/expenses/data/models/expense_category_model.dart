import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';

class ExpenseCategoryModel extends ExpenseCategoryEntity {
  ExpenseCategoryModel({super.id, required super.name});

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['idcategoria_gasto'],
      name: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'idcategoria_gasto': id, 'nombre': name};
  }
}
