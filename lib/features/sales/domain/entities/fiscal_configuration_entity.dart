import 'package:gestion_integral_jyc/features/sales/domain/entities/activity_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_point_entity.dart';

class FiscalConfigurationEntity {
  final String cuil;
  final List<ActivityEntity> activities;
  final List<SalePointEntity> salePoints;

  FiscalConfigurationEntity({
    required this.cuil,
    required this.activities,
    required this.salePoints,
  });

  bool get haveSalePoints => salePoints.isNotEmpty;
}
