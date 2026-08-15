import 'package:gestion_integral_jyc/core/enums/payment_method.dart';

class PartialPaymentEntity {
  final int? id;
  final double amount;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final int? workId;

  PartialPaymentEntity({
    required this.amount,
    required this.date,
    required this.paymentMethod,
    this.workId,
    this.id,
  });
}
