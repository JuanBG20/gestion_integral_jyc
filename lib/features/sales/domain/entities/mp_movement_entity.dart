import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';

class MpMovementEntity {
  final int? id;
  final String idMp;
  final DateTime date;
  final double amount;
  final PaymentMethod paymentMethod;
  final DocType? docType;
  final String? docNumber;
  final SaleEntity? sale;

  MpMovementEntity({
    required this.idMp,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    this.docType,
    this.docNumber,
    this.sale,
    this.id,
  });
}
