import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';

class SaleEntity {
  final int? id;
  final PaymentMethod paymentMethod;
  final DateTime date;
  final double finalAmount;
  final ClientEntity client;
  final WorkEntity? work;
  final List<SaleItemEntity> items;
  final BillEntity? bill;

  SaleEntity({
    required this.paymentMethod,
    required this.date,
    required this.finalAmount,
    required this.client,
    this.work,
    required this.items,
    this.bill,
    this.id,
  });

  bool get isInvoiced => bill != null && bill!.isSuccessful;
}
