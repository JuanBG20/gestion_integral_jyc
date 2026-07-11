import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

abstract class ProductLineItemEntity {
  VariantProductEntity? get variantProduct;
  int get quantity;
  double get unitPrice;
  String? get description;
}
