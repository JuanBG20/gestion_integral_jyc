import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class ProductGroupUi {
  final BaseProductEntity baseProduct;
  final List<VariantProductEntity> variants;

  ProductGroupUi({required this.baseProduct, required this.variants});

  int get totalStock => variants.fold(0, (sum, variant) => sum + variant.stock);
}
