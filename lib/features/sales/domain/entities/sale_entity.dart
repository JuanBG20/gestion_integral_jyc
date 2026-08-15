import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';

class SaleEntity {
  final int? id;
  final PaymentMethod? paymentMethod;
  final DateTime date;
  final double finalAmount;
  final ClientEntity client;
  final WorkEntity? work;
  final List<SaleItemEntity> items;
  final BillEntity? bill;
  final bool isPaid;

  SaleEntity({
    this.paymentMethod,
    required this.date,
    required this.finalAmount,
    required this.client,
    this.work,
    required this.items,
    this.bill,
    this.id,
    required this.isPaid,
  });

  bool get isInvoiced => bill != null && bill!.isSuccessful;

  SaleEntity copyWith({
    int? id,
    PaymentMethod? paymentMethod,
    DateTime? date,
    double? finalAmount,
    ClientEntity? client,
    WorkEntity? work,
    List<SaleItemEntity>? items,
    BillEntity? bill,
    bool? isPaid,
  }) {
    return SaleEntity(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      finalAmount: finalAmount ?? this.finalAmount,
      client: client ?? this.client,
      work: work ?? this.work,
      items: items ?? this.items,
      bill: bill ?? this.bill,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
