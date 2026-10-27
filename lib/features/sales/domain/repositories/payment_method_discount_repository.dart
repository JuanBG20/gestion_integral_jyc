import 'package:gestion_integral_jyc/features/sales/domain/entities/payment_method_discount_entity.dart';

abstract class PaymentMethodDiscountRepository {
  Future<List<PaymentMethodDiscountEntity>> getAll();
  Future<void> save(PaymentMethodDiscountEntity discount);
}
