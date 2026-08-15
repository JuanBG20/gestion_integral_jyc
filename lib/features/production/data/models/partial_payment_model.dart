import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/partial_payment_entity.dart';

class PartialPaymentModel extends PartialPaymentEntity {
  PartialPaymentModel({
    super.id,
    required super.amount,
    required super.date,
    required super.paymentMethod,
    super.workId,
  });

  factory PartialPaymentModel.fromJson(Map<String, dynamic> json) {
    return PartialPaymentModel(
      id: json['idpago_parcial'],
      amount: (json['monto'] as num).toDouble(),
      date: DateTime.parse(json['fecha']),
      paymentMethod: PaymentMethod.fromDB(json['metodo_pago']),
      workId: json['trabajo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idpago_parcial': id,
      'monto': amount,
      'metodo_pago': paymentMethod.dbValue,
      'trabajo': workId,
    };
  }
}
