import 'package:gestion_integral_jyc/features/inventory/data/models/base_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class VariantProductModel extends VariantProductEntity {
  VariantProductModel({
    super.id,
    required super.sku,
    required super.stock,
    required super.costPrice,
    required super.salePrice,
    super.color,
    super.size,
    required super.baseProduct,
    required super.manufacturingRecipe,
  });

  factory VariantProductModel.fromJson(
    Map<String, dynamic> json,
    BaseProductModel baseModel,
  ) {
    return VariantProductModel(
      id: json['idproducto_variante'],
      sku: json['sku_variante'],
      stock: json['stock'],
      costPrice: (json['precio_costo'] as num).toDouble(),
      salePrice: (json['precio_venta'] as num).toDouble(),
      color: json['color'],
      size: json['tamano'],
      baseProduct: baseModel,
      manufacturingRecipe:
          [], // Se poblaría si hacemos un JOIN complejo con fabrica
    );
  }

  Map<String, dynamic> toJson({required int baseProductId}) {
    return {
      if (id != null) 'idproducto_variante': id,
      'sku_variante': sku,
      'stock': stock,
      'precio_costo': costPrice,
      'precio_venta': salePrice,
      'color': color,
      'tamano': size,
      'producto_base': baseProductId,
    };
  }
}
