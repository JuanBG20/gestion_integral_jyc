import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';

abstract class MpMovementRepository {
  Future<List<MpMovementEntity>> getMovements();
  Future<void> linkToSale(int movementId, int saleId);
}
