import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:riverpod/legacy.dart';

final saleStateFilterProvider = StateProvider<String?>((ref) => null);

final salePaymentMethodFilterProvider = StateProvider<PaymentMethod?>(
  (ref) => null,
);
