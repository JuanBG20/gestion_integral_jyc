import 'package:gestion_integral_jyc/core/enums/discount_origin.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';

class DiscountCalculator {
  static List<DiscountEntity> calculatePaymenthMethodDiscounts({
    required PaymentMethod method,
    required double subtotal,
    required double percentage,
  }) {
    if (subtotal <= 0 || percentage <= 0) return [];

    return [
      DiscountEntity(
        reason: method.dbValue,
        amount: subtotal * percentage / 100,
        origin: DiscountOrigin.metodoPago,
        percentage: percentage,
      ),
    ];
  }
}
