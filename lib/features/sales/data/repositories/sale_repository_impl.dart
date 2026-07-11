import 'package:gestion_integral_jyc/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/sale_repository.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remoteDataSource;

  SaleRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createSale(SaleEntity sale) async {
    final saleModel = SaleModel(
      paymentMethod: sale.paymentMethod,
      date: sale.date,
      finalAmount: sale.finalAmount,
      client: sale.client,
      work: sale.work,
      items: sale.items
          .map(
            (i) => SaleItemModel(
              variantProduct: i.variantProduct,
              quantity: i.quantity,
              unitPrice: i.unitPrice,
              description: i.description,
            ),
          )
          .toList(),
    );
    await remoteDataSource.createSaleRPC(saleModel);
  }

  @override
  Future<List<SaleEntity>> getSales() async {
    return await remoteDataSource.fetchSales();
  }
}
