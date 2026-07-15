import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/mp_movement_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/mp_movement_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/mp_movement_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final mpMovementDataSourceProvider = Provider<MpMovementRemoteDataSource>((
  ref,
) {
  return MpMovementRemoteDataSource(Supabase.instance.client);
});

final mpMovementRepositoryProvider = Provider<MpMovementRepository>((ref) {
  return MpMovementRepositoryImpl(ref.read(mpMovementDataSourceProvider));
});

final mpMovementsProvider =
    StateNotifierProvider<
      MpMovementNotifier,
      AsyncValue<List<MpMovementEntity>>
    >((ref) {
      return MpMovementNotifier(ref.read(mpMovementRepositoryProvider));
    });

class MpMovementNotifier
    extends StateNotifier<AsyncValue<List<MpMovementEntity>>> {
  final MpMovementRepository repository;

  MpMovementNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchMovements();
  }

  Future<void> fetchMovements() async {
    try {
      state = const AsyncValue.loading();
      final movements = await repository.getMovements();
      state = AsyncValue.data(movements);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> linkToSale(int movementId, int saleId) async {
    try {
      await repository.linkToSale(movementId, saleId);
      await fetchMovements();
    } catch (e) {
      throw Exception('Error al vincular: $e');
    }
  }
}
