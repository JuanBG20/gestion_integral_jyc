import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/clients/data/models/client_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class SaleModel extends SaleEntity {
  SaleModel({
    super.id,
    required super.paymentMethod,
    required super.date,
    required super.finalAmount,
    required super.client,
    super.work,
    required super.items,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['contiene_venta'] as List?)
            ?.map((itemJson) => SaleItemModel.fromJson(itemJson))
            .toList() ??
        [];

    WorkModel? linkedWork;
    if (json['venta_trabajo'] != null &&
        (json['venta_trabajo'] as List).isNotEmpty) {
      final workJson = json['venta_trabajo'][0]['trabajo'];
      if (workJson != null) {
        linkedWork = WorkModel.fromJson(workJson);
      }
    }

    return SaleModel(
      id: json['idventa'],
      paymentMethod: PaymentMethod.fromDB(json['metodo_pago']),
      date: DateTime.parse(json['fecha']),
      finalAmount: (json['monto_total'] as num).toDouble(),
      client: ClientModel.fromJson(json['cliente']),
      work: linkedWork,
      items: itemsList,
    );
  }
}
