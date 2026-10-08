import 'package:gestion_integral_jyc/features/sales/data/models/arca_data_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  BillModel({
    super.id,
    super.arcaData,
    required super.isSuccessful,
    required super.isManual,
    required super.emissionDate,
    super.cae,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['idfactura'],
      arcaData: json['respuesta_arca'] != null
          ? ArcaDataModel.fromJson(
              json['respuesta_arca'] as Map<String, dynamic>? ?? {},
            )
          : null,
      isSuccessful: json['exitoso'] ?? false,
      emissionDate: DateTime.parse(json['fecha_emision']).toLocal(),
      cae: json['cae'],
      isManual: json['es_manual'],
    );
  }
}
