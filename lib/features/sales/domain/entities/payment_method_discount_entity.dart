import 'package:gestion_integral_jyc/core/enums/payment_method.dart';

class PaymentMethodDiscountEntity {
  final PaymentMethod method;
  final bool applies;
  final double percentage;

  PaymentMethodDiscountEntity({
    required this.method,
    required this.applies,
    required this.percentage,
  });

  double get effectivePercentage => applies ? percentage : 0;

  PaymentMethodDiscountEntity copyWith({bool? applies, double? percentage}) =>
      PaymentMethodDiscountEntity(
        method: method,
        applies: applies ?? this.applies,
        percentage: percentage ?? this.percentage,
      );
}
