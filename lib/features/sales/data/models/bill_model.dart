import 'package:gestion_integral_jyc/features/sales/data/models/arca_data_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  BillModel({
    super.id,
    required super.arcaData,
    required super.isSuccessful,
    required super.emissionDate,
    super.cae,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['idfactura'],
      arcaData: ArcaDataModel.fromJson(
        json['respuesta_arca'] as Map<String, dynamic>? ?? {},
      ),
      isSuccessful: json['exitoso'] ?? false,
      emissionDate: DateTime.parse(json['fecha_emision']),
      cae: json['cae'],
    );
  }
}
