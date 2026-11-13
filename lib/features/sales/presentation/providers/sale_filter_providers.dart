import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:riverpod/legacy.dart';

final saleMonthFilterProvider = StateProvider<DateTime>(
  (ref) => currentMonthStart(),
);

final saleStateFilterProvider = StateProvider<String?>((ref) => null);

final salePaymentMethodFilterProvider = StateProvider<PaymentMethod?>(
  (ref) => null,
);
