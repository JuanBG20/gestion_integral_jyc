import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';

class DiscountCalculator {
  // Descuento por pago en efectivo
  static const double cashDiscountPercentage = 0.10;

  static List<DiscountEntity> calculatePaymenthMethodDiscounts({
    required PaymentMethod method,
    required double subtotal,
  }) {
    if (subtotal <= 0) return [];

    final List<DiscountEntity> discounts = [];

    if (method == PaymentMethod.efectivo) {
      final amount = subtotal * cashDiscountPercentage;
      discounts.add(
        DiscountEntity(
          reason: 'Efectivo ${(cashDiscountPercentage * 100).toInt()}%',
          amount: amount,
        ),
      );
    }

    return discounts;
  }
}
