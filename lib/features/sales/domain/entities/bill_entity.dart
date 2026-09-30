import 'package:gestion_integral_jyc/features/sales/domain/entities/arca_data_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class BillEntity {
  final int? id;
  final ArcaDataEntity? arcaData;
  final bool isSuccessful;
  final bool isManual;
  final DateTime emissionDate;
  final String? cae;
  final SaleEntity? sale;

  BillEntity({
    this.arcaData,
    required this.isSuccessful,
    required this.isManual,
    required this.emissionDate,
    this.cae,
    this.sale,
    this.id,
  });
}
