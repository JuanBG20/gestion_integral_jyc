import 'package:gestion_integral_jyc/features/sales/data/datasources/bill_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/sale_repository.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remoteDataSource;
  final BillRemoteDataSource billRemoteDataSource;

  SaleRepositoryImpl(this.remoteDataSource, this.billRemoteDataSource);

  @override
  Future<SaleEntity> createSale(
    SaleEntity sale, {
    int? materiaPrimaId,
    double? consumo,
  }) async {
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
    final newSaleId = await remoteDataSource.createSaleRPC(
      saleModel,
      materiaPrimaId: materiaPrimaId,
      consumo: consumo,
    );

    return sale.copyWith(id: newSaleId);
  }

  @override
  Future<List<SaleEntity>> getSales() async {
    return await remoteDataSource.fetchSales();
  }

  @override
  Future<void> emitInvoice(
    int saleId, {
    required int condicionIvaReceptorId,
    required DateTime issueDate,
    int concepto = 1,
  }) async {
    await billRemoteDataSource.emitInvoice(
      saleId: saleId,
      condicionIvaReceptorId: condicionIvaReceptorId,
      concepto: concepto,
      issueDate: issueDate,
    );
  }
}
