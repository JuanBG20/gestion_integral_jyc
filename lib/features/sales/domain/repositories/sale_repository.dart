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
}
