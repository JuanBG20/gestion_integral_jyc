import 'package:gestion_integral_jyc/features/sales/domain/entities/arca_data_entity.dart';

class ArcaDataModel extends ArcaDataEntity {
  ArcaDataModel({
    required super.cae,
    required super.caeVencimiento,
    required super.fechaComprobante,
    required super.impTotal,
    required super.ptoVta,
    required super.cbteTipo,
    required super.cbteNro,
    required super.concepto,
    required super.docTipo,
    required super.docNro,
    required super.condicionIvaReceptorId,
  });

  factory ArcaDataModel.fromJson(Map<String, dynamic> json) {
    final arca = json['arca'] as Map<String, dynamic>? ?? {};
    final response = arca['response'] as Map<String, dynamic>? ?? {};
    final feCabResp = response['FeCabResp'] as Map<String, dynamic>? ?? {};
    final feDetResp = response['FeDetResp'] as Map<String, dynamic>? ?? {};
    final detalles = feDetResp['FECAEDetResponse'] as List? ?? [];
    final detalle = detalles.isNotEmpty
        ? detalles.first as Map<String, dynamic>
        : <String, dynamic>{};

    DateTime parseAfipDate(String? raw) {
      if (raw == null || raw.length != 8) return DateTime.now();
      return DateTime(
        int.parse(raw.substring(0, 4)),
        int.parse(raw.substring(4, 6)),
        int.parse(raw.substring(6, 8)),
      );
    }

    return ArcaDataModel(
      cae: arca['cae']?.toString() ?? '',
      caeVencimiento: parseAfipDate(arca['caeFchVto']?.toString()),
      fechaComprobante: parseAfipDate(arca['CbteFch']?.toString()),
      impTotal: (json['impTotal'] as num?)?.toDouble() ?? 0.0,
      ptoVta: (feCabResp['PtoVta'] as num?)?.toInt() ?? 0,
      cbteTipo: (feCabResp['CbteTipo'] as num?)?.toInt() ?? 0,
      cbteNro: (detalle['CbteDesde'] as num?)?.toInt() ?? 0,
      concepto: (json['concepto'] as num?)?.toInt() ?? 1,
      docTipo: (json['docTipo'] as num?)?.toInt() ?? 99,
      docNro: (json['docNro'] as num?)?.toInt() ?? 0,
      condicionIvaReceptorId:
          (json['condicionIvaReceptorId'] as num?)?.toInt() ?? 5,
    );
  }
}
