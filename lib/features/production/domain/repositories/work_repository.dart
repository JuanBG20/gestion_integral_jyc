import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/partial_payment_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';

abstract class WorkRepository {
  Future<List<WorkEntity>> getWorks();
  Future<void> createWork(WorkEntity work);
  Future<void> updateWork(WorkEntity work);
  Future<void> updateWorkState(int workId, WorkState newState);
  Future<void> updateWorkItemDone(int itemId, bool isDone);
  Future<void> addPartialPayment(PartialPaymentEntity payment);
}
