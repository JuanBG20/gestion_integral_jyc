import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

abstract class SaleRepository {
  Future<List<SaleEntity>> getSales();
  Future<SaleEntity> createSale(
    SaleEntity sale, {
    int? materiaPrimaId,
    double? consumo,
  });
  Future<void> emitInvoice(
    int saleId, {
    required int condicionIvaReceptorId,
    required DateTime issueDate,
    int concepto = 1,
  });
  Future<void> markSaleAsPaid(
    int saleId,
    PaymentMethod paymentMethod, {
    List<DiscountEntity> additionalDiscounts = const [],
  });
}
