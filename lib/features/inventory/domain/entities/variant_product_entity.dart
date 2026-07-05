import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';

class VariantProductEntity {
  final int? id;
  final String sku;
  final int stock;
  final double costPrice;
  final double salePrice;
  final String? color;
  final String? size;
  final BaseProductEntity baseProduct;
  final List<MaterialRecipeEntity> manufacturingRecipe;

  VariantProductEntity({
    required this.sku,
    required this.stock,
    required this.costPrice,
    required this.salePrice,
    this.color,
    this.size,
    required this.baseProduct,
    required this.manufacturingRecipe,
    this.id,
  });
}
