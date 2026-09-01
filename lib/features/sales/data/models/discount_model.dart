import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';

class DiscountModel extends DiscountEntity {
  DiscountModel({super.id, required super.reason, required super.amount});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['idventa_descuento'],
      reason: json['motivo'],
      amount: (json['monto_descontado'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idventa_descuento': id,
      'motivo': reason,
      'monto_descontado': amount,
    };
  }
}
