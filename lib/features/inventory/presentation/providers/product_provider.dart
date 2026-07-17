import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/inventory/data/datasources/product_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/repositories/product_repository_impl.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/product_repository.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final productDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource(Supabase.instance.client);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.read(productDataSourceProvider));
});

final inventoryProductsProvider =
    StateNotifierProvider<
      InventoryProductsNotifier,
      AsyncValue<List<ProductGroupUi>>
    >((ref) {
      return InventoryProductsNotifier(ref.read(productRepositoryProvider));
    });

class InventoryProductsNotifier
    extends StateNotifier<AsyncValue<List<ProductGroupUi>>> {
  final ProductRepository repository;

  InventoryProductsNotifier(this.repository)
    : super(const AsyncValue.loading()) {
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    try {
      state = const AsyncValue.loading();
      final groups = await repository.getInventoryGroups();
      state = AsyncValue.data(groups);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProductWithVariants(
    BaseProductEntity base,
    List<VariantProductEntity> variants,
  ) async {
    try {
      await repository.createFullProduct(base, variants);
      await fetchInventory(); // Refrescamos la UI
    } catch (e) {
      throw Exception('Error al guardar el producto: $e');
    }
  }

  Future<void> updateProductWithVariants(
    BaseProductEntity base,
    List<VariantProductEntity> variants,
  ) async {
    try {
      await repository.updateFullProduct(base, variants);
      await fetchInventory(); // Refrescamos la UI
    } catch (e) {
      throw Exception('Error al actualizar el producto: $e');
    }
  }

  Future<void> removeProductWithVariants(int id) async {
    try {
      await repository.deleteProductWithVariants(id);
      await fetchInventory();
    } catch (e) {
      throw Exception('Error al eliminar producto con variantes: $e');
    }
  }

  Future<void> removeVariant(int id) async {
    try {
      await repository.deleteVariant(id);
      await fetchInventory();
    } catch (e) {
      throw Exception('Error al eliminar variante: $e');
    }
  }

  Future<void> updateStock(int variantId, double delta, bool deductMp) async {
    await repository.updateStock(variantId, delta, deductMp);
    await fetchInventory();
  }
}
