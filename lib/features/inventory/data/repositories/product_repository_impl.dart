import 'package:gestion_integral_jyc/features/inventory/data/datasources/product_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/base_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/variant_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/product_repository.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createFullProduct(
    BaseProductEntity baseProduct,
    List<VariantProductEntity> variants,
  ) async {
    final baseModel = BaseProductModel(
      baseSku: baseProduct.baseSku,
      category: baseProduct.category,
      subcategory: baseProduct.subcategory,
      description: baseProduct.description,
    );

    final variantModels = variants
        .map(
          (v) => VariantProductModel(
            sku: v.sku,
            stock: v.stock,
            costPrice: v.costPrice,
            salePrice: v.salePrice,
            color: v.color,
            size: v.size,
            baseProduct: baseModel,
            manufacturingRecipe: v.manufacturingRecipe,
          ),
        )
        .toList();

    await remoteDataSource.createFullProductRPC(baseModel, variantModels);
  }

  @override
  Future<void> deleteProductWithVariants(int id) async {
    await remoteDataSource.deleteProductWithVariants(id);
  }

  @override
  Future<void> deleteVariant(int id) async {
    await remoteDataSource.deleteVariant(id);
  }

  @override
  Future<List<ProductGroupUi>> getInventoryGroups() async {
    final rawData = await remoteDataSource.fetchInventoryWithVariants();

    return rawData.map((jsonGroup) {
      final baseModel = BaseProductModel.fromJson(jsonGroup);
      final variantsJson =
          jsonGroup['producto_variante'] as List<dynamic>? ?? [];

      final variants = variantsJson.map((vJson) {
        return VariantProductModel.fromJson(vJson, baseModel);
      }).toList();

      return ProductGroupUi(baseProduct: baseModel, variants: variants);
    }).toList();
  }

  @override
  Future<void> updateStock(int variantId, double delta, bool deductMp) async {
    await remoteDataSource.updateStock(variantId, delta, deductMp);
  }

  @override
  Future<void> updateFullProduct(
    BaseProductEntity baseProduct,
    List<VariantProductEntity> variants,
  ) async {
    final baseModel = BaseProductModel(
      id: baseProduct.id,
      baseSku: baseProduct.baseSku,
      category: baseProduct.category,
      subcategory: baseProduct.subcategory,
      description: baseProduct.description,
    );

    final variantModels = variants
        .map(
          (v) => VariantProductModel(
            id: v.id,
            sku: v.sku,
            stock: v.stock,
            costPrice: v.costPrice,
            salePrice: v.salePrice,
            color: v.color,
            size: v.size,
            baseProduct: baseModel,
            manufacturingRecipe: v.manufacturingRecipe,
          ),
        )
        .toList();

    await remoteDataSource.updateFullProduct(baseModel, variantModels);
  }
}
