import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/domain/services/analytics_service.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/analytics_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/bill_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
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
      return SaleNotifier(
        repository: ref.read(saleRepositoryProvider),
        ref: ref,
        analytics: ref.read(analyticsProvider),
      );
    });

class SaleNotifier extends StateNotifier<AsyncValue<List<SaleEntity>>> {
  final SaleRepository repository;
  final AnalyticsService analytics;
  final Ref ref;

  SaleNotifier({
    required this.repository,
    required this.analytics,
    required this.ref,
  }) : super(const AsyncValue.loading()) {
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
        ref.invalidate(inventoryProductsProvider);
      }

      if (materiaPrimaId != null) {
        ref.invalidate(rawMaterialProvider);
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

    await analytics.logSaleCreated();
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

    await analytics.logInvoiceGenerated(isManual: false);
  }

  Future<void> markSaleAsPaid(
    int saleId,
    PaymentMethod paymentMethod, {
    List<DiscountEntity> additionalDiscounts = const [],
  }) async {
    try {
      // 1. Optimistic Update (Opcional, pero da mejor UX)
      if (state is AsyncData) {
        final currentSales = state.value!;
        final newSales = currentSales.map((s) {
          if (s.id == saleId) {
            final newDiscountsAmount = additionalDiscounts.fold(
              0.0,
              (sum, d) => sum + d.amount,
            );

            return s.copyWith(
              isPaid: true,
              paymentMethod: paymentMethod,
              discounts: [...s.discounts, ...additionalDiscounts],
              finalAmount: s.finalAmount - newDiscountsAmount,
            );
          }
          return s;
        }).toList();
        state = AsyncValue.data(newSales);
      }

      // 2. Llamada real a la BD
      await repository.markSaleAsPaid(
        saleId,
        paymentMethod,
        additionalDiscounts: additionalDiscounts,
      );

      // 3. Re-sync por seguridad
      await fetchSales();
    } catch (e) {
      await fetchSales(); // Rollback en caso de error
      throw Exception('Error al registrar el pago: $e');
    }
  }

  Future<void> markAsManuallyInvoiced(int saleId) async {
    try {
      await repository.markAsManuallyInvoiced(saleId);
      await fetchSales();

      await analytics.logInvoiceGenerated(isManual: true);
    } catch (e) {
      throw Exception('Error al registrar factura manual: $e');
    }
  }
}
