import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';

abstract class ProductRepository {
  Future<List<ProductGroupUi>> getInventoryGroups();
  Future<void> createFullProduct(
    BaseProductEntity baseProduct,
    List<VariantProductEntity> variants,
  );
  Future<void> deleteProductWithVariants(int id);
  Future<void> deleteVariant(int id);
  Future<void> updateStock(int variantId, double delta, bool deductMp);
  Future<void> updateFullProduct(
    BaseProductEntity baseProduct,
    List<VariantProductEntity> variants,
  );
}
