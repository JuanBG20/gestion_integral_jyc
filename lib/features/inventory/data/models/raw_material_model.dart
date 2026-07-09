import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';

class RawMaterialModel extends RawMaterialEntity {
  RawMaterialModel({
    super.id,
    required super.sku,
    required super.stock,
    required super.category,
    required super.subcategory,
    required super.description,
    required super.minStock,
  });

  factory RawMaterialModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialModel(
      id: json['idmateria_prima'],
      sku: json['sku'],
      stock: json['stock'],
      category: json['categoria'],
      subcategory: json['subcategoria'],
      description: json['descripcion'],
      minStock: json['stock_minimo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idmateria_prima': id,
      'sku': sku,
      'stock': stock,
      'categoria': category,
      'subcategoria': subcategory,
      'descripcion': description,
      'stock_minimo': minStock,
    };
  }
}
