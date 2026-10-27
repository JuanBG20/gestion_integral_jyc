import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/payment_method_discount_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/payment_method_discount_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/payment_method_discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/payment_method_discount_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final paymentMethodDiscountRepositoryProvider =
    Provider<PaymentMethodDiscountRepository>(
      (ref) => PaymentMethodDiscountRepositoryImpl(
        PaymentMethodDiscountRemoteDataSource(Supabase.instance.client),
      ),
    );

class PaymentMethodDiscountsNotifier
    extends AsyncNotifier<List<PaymentMethodDiscountEntity>> {
  @override
  Future<List<PaymentMethodDiscountEntity>> build() =>
      ref.read(paymentMethodDiscountRepositoryProvider).getAll();

  Future<void> save(PaymentMethodDiscountEntity discount) async {
    await ref.read(paymentMethodDiscountRepositoryProvider).save(discount);

    state = AsyncData([
      for (final d in state.requireValue)
        d.method == discount.method ? discount : d,
    ]);
  }
}

final paymentMethodDiscountsProvider =
    AsyncNotifierProvider<
      PaymentMethodDiscountsNotifier,
      List<PaymentMethodDiscountEntity>
    >(PaymentMethodDiscountsNotifier.new);
