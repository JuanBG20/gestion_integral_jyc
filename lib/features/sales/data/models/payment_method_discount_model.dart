import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/payment_method_discount_entity.dart';

class PaymentMethodDiscountModel extends PaymentMethodDiscountEntity {
  PaymentMethodDiscountModel({
    required super.method,
    required super.applies,
    required super.percentage,
  });

  factory PaymentMethodDiscountModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDiscountModel(
        method: PaymentMethod.fromDB(json['metodo_pago']),
        applies: json['aplica_descuento'] as bool,
        percentage: (json['porcentaje_descuento'] as num).toDouble(),
      );

  factory PaymentMethodDiscountModel.fromEntity(
    PaymentMethodDiscountEntity e,
  ) => PaymentMethodDiscountModel(
    method: e.method,
    applies: e.applies,
    percentage: e.percentage,
  );

  Map<String, dynamic> toJson() => {
    'metodo_pago': method.dbValue,
    'aplica_descuento': applies,
    'porcentaje_descuento': percentage,
  };
}
