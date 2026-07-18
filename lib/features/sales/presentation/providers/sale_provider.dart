import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/bill_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/sale_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final saleDataSourceProvider = Provider<SaleRemoteDataSource>((ref) {
  return SaleRemoteDataSource(Supabase.instance.client);
});

final billDataSourceProvider = Provider<BillRemoteDataSource>((ref) {
  return BillRemoteDataSource(Supabase.instance.client);
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryImpl(
    ref.read(saleDataSourceProvider),
    ref.read(billDataSourceProvider),
  );
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

  Future<SaleEntity> createSale(
    SaleEntity sale, {
    int? materiaPrimaId,
    double? consumo,
  }) async {
    try {
      final savedSale = await repository.createSale(
        sale,
        materiaPrimaId: materiaPrimaId,
        consumo: consumo,
      );
      await fetchSales();

      if (sale.work == null) {
        ref.read(inventoryProductsProvider.notifier).fetchInventory();
      }

      if (materiaPrimaId != null) {
        ref.read(rawMaterialProvider.notifier).fetchRawMaterials();
      }

      return savedSale;
    } catch (e) {
      throw Exception('Error al registrar la venta: $e');
    }
  }

  Future<void> addSale(
    SaleEntity sale, {
    int? materiaPrimaId,
    double? consumo,
  }) async {
    await createSale(sale, materiaPrimaId: materiaPrimaId, consumo: consumo);
  }

  Future<void> emitInvoice(
    int saleId, {
    required int condicionIvaReceptorId,
    required DateTime issueDate,
    int concepto = 1,
  }) async {
    await repository.emitInvoice(
      saleId,
      condicionIvaReceptorId: condicionIvaReceptorId,
      concepto: concepto,
      issueDate: issueDate,
    );
    await fetchSales();
  }
}
