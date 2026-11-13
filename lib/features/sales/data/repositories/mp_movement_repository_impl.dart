import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/mp_movement_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/mp_movement_repository.dart';

class MpMovementRepositoryImpl implements MpMovementRepository {
  final MpMovementRemoteDataSource remoteDataSource;

  MpMovementRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MpMovementEntity>> getMovements(DateTime month) async {
    return await remoteDataSource.getMovements(
      from: month.monthStart,
      to: month.nextMonthStart,
    );
  }

  @override
  Future<void> linkToSale(int movementId, int saleId) async {
    return await remoteDataSource.linkToSale(movementId, saleId);
  }
}
