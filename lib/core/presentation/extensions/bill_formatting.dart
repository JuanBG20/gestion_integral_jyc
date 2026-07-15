import 'package:gestion_integral_jyc/core/enums/condicion_iva_receptor.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';

extension BillFormatting on BillEntity {
  String get letraComprobante {
    switch (arcaData.cbteTipo) {
      case 1:
        return 'A';
      case 6:
        return 'B';
      case 11:
      default:
        return 'C';
    }
  }

  String get codigoComprobante {
    switch (arcaData.cbteTipo) {
      case 1:
        return '001';
      case 6:
        return '006';
      case 11:
      default:
        return '011';
    }
  }

  String get docTipoLabel {
    switch (arcaData.docTipo) {
      case 80:
        return 'CUIT';
      case 86:
        return 'CUIL';
      case 87:
        return 'DNI';
      default:
        return 'DNI';
    }
  }

  bool get isConsumidorFinalAnonimo => arcaData.docTipo == 99;

  String get condicionIvaReceptorLabel {
    return CondicionIvaReceptor.values
        .firstWhere(
          (c) => c.arcaId == arcaData.condicionIvaReceptorId,
          orElse: () => CondicionIvaReceptor.consumidorFinal,
        )
        .label;
  }
}
