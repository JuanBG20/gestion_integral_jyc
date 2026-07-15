import 'package:gestion_integral_jyc/features/sales/data/datasources/mp_movement_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/mp_movement_repository.dart';

class MpMovementRepositoryImpl implements MpMovementRepository {
  final MpMovementRemoteDataSource remoteDataSource;

  MpMovementRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MpMovementEntity>> getMovements() async {
    return await remoteDataSource.getMovements();
  }

  @override
  Future<void> linkToSale(int movementId, int saleId) async {
    return await remoteDataSource.linkToSale(movementId, saleId);
  }
}
