import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

abstract class SaleRepository {
  Future<List<SaleEntity>> getSales();
  Future<void> createSale(
    SaleEntity sale, {
    int? materiaPrimaId,
    double? consumo,
  });
}
