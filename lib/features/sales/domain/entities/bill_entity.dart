import 'package:gestion_integral_jyc/features/sales/domain/entities/arca_data_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class BillEntity {
  final int? id;
  final ArcaDataEntity arcaData;
  final bool isSuccessful;
  final DateTime emissionDate;
  final String? cae;
  final SaleEntity sale;

  BillEntity({
    required this.arcaData,
    required this.isSuccessful,
    required this.emissionDate,
    this.cae,
    required this.sale,
    this.id,
  });
}
