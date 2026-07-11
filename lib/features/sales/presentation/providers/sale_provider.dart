import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/sale_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final saleDataSourceProvider = Provider<SaleRemoteDataSource>((ref) {
  return SaleRemoteDataSource(Supabase.instance.client);
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryImpl(ref.read(saleDataSourceProvider));
});

final saleProvider =
    StateNotifierProvider<SaleNotifier, AsyncValue<List<SaleEntity>>>((ref) {
      return SaleNotifier(ref.read(saleRepositoryProvider), ref);
    });

class SaleNotifier extends StateNotifier<AsyncValue<List<SaleEntity>>> {
  final SaleRepository repository;
  final Ref ref;

  SaleNotifier(this.repository, this.ref) : super(const AsyncValue.loading()) {
    fetchSales();
  }

  Future<void> fetchSales() async {
    try {
      state = const AsyncValue.loading();
      final sales = await repository.getSales();
      state = AsyncValue.data(sales);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addSale(SaleEntity sale) async {
    try {
      await repository.createSale(sale);
      await fetchSales();

      // Si fue una venta directa, recargamos el inventario porque el stock bajó en la base de datos
      if (sale.work == null) {
        ref.read(inventoryProductsProvider.notifier).fetchInventory();
      }
    } catch (e) {
      throw Exception('Error al registrar la venta: $e');
    }
  }
}
