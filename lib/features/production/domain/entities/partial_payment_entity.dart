import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';

class PartialPaymentEntity {
  final int? id;
  final double amount;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final WorkEntity work;

  PartialPaymentEntity({
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.work,
    this.id,
  });
}
