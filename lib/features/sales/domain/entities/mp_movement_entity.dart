import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';

class MpMovementEntity {
  final int? id;
  final String idMp;
  final DateTime date;
  final double amount;
  final PaymentMethod paymentMethod;
  final DocType? docType;
  final String? docNumber;
  final List<int>? saleIds;

  MpMovementEntity({
    required this.idMp,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    this.docType,
    this.docNumber,
    this.saleIds,
    this.id,
  });
}
