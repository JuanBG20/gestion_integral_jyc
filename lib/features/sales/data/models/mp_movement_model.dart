import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';

class MpMovementModel extends MpMovementEntity {
  MpMovementModel({
    super.id,
    required super.idMp,
    required super.date,
    required super.amount,
    required super.paymentMethod,
    super.docType,
    super.docNumber,
    super.saleIds,
  });

  factory MpMovementModel.fromJson(Map<String, dynamic> json) {
    List<int> saleIds = [];
    final rawMpVenta = json['mp_venta'];

    if (rawMpVenta != null) {
      if (rawMpVenta is Map && rawMpVenta.containsKey('venta')) {
        saleIds = [(rawMpVenta['venta'] as num).toInt()];
      } else if (rawMpVenta is List) {
        saleIds = rawMpVenta.map((e) => (e['venta'] as num).toInt()).toList();
      }
    }

    return MpMovementModel(
      id: json['idmovimiento_mp'],
      idMp: json['id_mp'],
      date: DateTime.parse(json['fecha']),
      amount: (json['monto'] as num).toDouble(),
      paymentMethod: PaymentMethod.fromDB(json['metodo_pago']),
      docType: _parseDocType(json['tipo_documento']),
      docNumber: json['num_documento'],
      saleIds: saleIds,
    );
  }

  // Helper para limpiar el DocType
  static DocType? _parseDocType(dynamic value) {
    if (value == null) return null;
    try {
      return DocType.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toString().toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
