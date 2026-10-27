import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/payment_method_discount_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/payment_method_discount_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/payment_method_discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/payment_method_discount_repository.dart';

class PaymentMethodDiscountRepositoryImpl
    implements PaymentMethodDiscountRepository {
  final PaymentMethodDiscountRemoteDataSource remoteDataSource;

  PaymentMethodDiscountRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PaymentMethodDiscountEntity>> getAll() async {
    final rows = await remoteDataSource.fetchAll();
    final byMethod = {for (final r in rows) r.method: r};

    return PaymentMethod.values
        .map(
          (m) =>
              byMethod[m] ??
              PaymentMethodDiscountEntity(
                method: m,
                applies: false,
                percentage: 0,
              ),
        )
        .toList();
  }

  @override
  Future<void> save(PaymentMethodDiscountEntity discount) =>
      remoteDataSource.upsert(PaymentMethodDiscountModel.fromEntity(discount));
}
