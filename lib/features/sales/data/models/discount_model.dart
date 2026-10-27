import 'package:gestion_integral_jyc/core/enums/discount_origin.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';

class DiscountModel extends DiscountEntity {
  DiscountModel({
    super.id,
    required super.reason,
    required super.amount,
    super.origin,
    super.percentage,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    final origin = json['origen'] as String?;

    return DiscountModel(
      id: json['idventa_descuento'],
      reason: json['motivo'],
      amount: (json['monto_descontado'] as num).toDouble(),
      origin: origin != null
          ? DiscountOrigin.fromDB(origin)
          : DiscountOrigin.otro,
      percentage: (json['porcentaje'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idventa_descuento': id,
      'motivo': reason,
      'monto_descontado': amount,
      'origen': origin.dbValue,
      'porcentaje': percentage,
    };
  }

  factory DiscountModel.fromEntity(DiscountEntity e) => DiscountModel(
    id: e.id,
    reason: e.reason,
    amount: e.amount,
    origin: e.origin,
    percentage: e.percentage,
  );
}
