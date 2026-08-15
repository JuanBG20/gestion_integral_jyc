import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/partial_payment_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';

class WorkEntity {
  final int? id;
  final DateTime creationDate;
  final DateTime? deadline;
  final ClientEntity client;
  final WorkState actualState;
  final List<WorkItemEntity> items;
  final List<PartialPaymentEntity> partialPayments;

  WorkEntity({
    required this.creationDate,
    required this.deadline,
    required this.client,
    required this.actualState,
    required this.items,
    required this.partialPayments,
    this.id,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + (item.subtotal));

  // Total señado
  double get totalPaid => partialPayments.fold(
    0,
    (sum, partialPayment) => sum + partialPayment.amount,
  );

  // Total pendiente de pago
  double get totalOutstanding => totalAmount - totalPaid;
}
