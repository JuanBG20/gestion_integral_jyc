import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/clients/data/models/client_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/bill_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/discount_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class SaleModel extends SaleEntity {
  SaleModel({
    super.id,
    super.paymentMethod,
    required super.date,
    required super.finalAmount,
    required super.client,
    super.work,
    required super.items,
    super.bill,
    required super.isPaid,
    required super.subtotal,
    required super.discounts,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['contiene_venta'] as List?)
            ?.map((itemJson) => SaleItemModel.fromJson(itemJson))
            .toList() ??
        [];

    final discountsList =
        (json['venta_descuento'] as List?)
            ?.map((discountJson) => DiscountModel.fromJson(discountJson))
            .toList() ??
        [];

    WorkModel? linkedWork;
    if (json['venta_trabajo'] != null &&
        (json['venta_trabajo'] as List).isNotEmpty) {
      final workJson = json['venta_trabajo'][0]['trabajo'];

      if (workJson != null && workJson is Map<String, dynamic>) {
        linkedWork = WorkModel.fromJson(workJson);
      }
    }

    BillModel? bill;
    final facturas = (json['factura'] as List?)
        ?.where((f) => f['exitoso'] == true)
        .toList();
    if (facturas != null && facturas.isNotEmpty) {
      facturas.sort(
        (a, b) => DateTime.parse(
          b['fecha_emision'],
        ).compareTo(DateTime.parse(a['fecha_emision'])),
      );
      bill = BillModel.fromJson(facturas.first);
    }

    return SaleModel(
      id: json['idventa'],
      paymentMethod: json['metodo_pago'] != null
          ? PaymentMethod.fromDB(json['metodo_pago'])
          : null,
      date: DateTime.parse(json['fecha']),
      finalAmount: (json['monto_total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      client: ClientModel.fromJson(json['cliente']),
      work: linkedWork,
      items: itemsList,
      discounts: discountsList,
      bill: bill,
      isPaid: json['esta_pagado'],
    );
  }
}
