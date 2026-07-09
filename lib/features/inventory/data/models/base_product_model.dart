import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';

class BaseProductModel extends BaseProductEntity {
  BaseProductModel({
    super.id,
    required super.baseSku,
    required super.category,
    required super.subcategory,
    required super.description,
  });

  factory BaseProductModel.fromJson(Map<String, dynamic> json) {
    return BaseProductModel(
      id: json['idproducto_base'],
      baseSku: json['sku_base'],
      category: json['categoria'],
      subcategory: json['subcategoria'],
      description: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idproducto_base': id,
      'sku_base': baseSku,
      'categoria': category,
      'subcategoria': subcategory,
      'descripcion': description,
    };
  }
}
