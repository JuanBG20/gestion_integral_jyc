import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/data/datasources/work_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/production/data/repositories/work_repository_impl.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/repositories/work_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final workDataSourceProvider = Provider<WorkRemoteDataSource>((ref) {
  return WorkRemoteDataSource(Supabase.instance.client);
});

final workRepositoryProvider = Provider<WorkRepository>((ref) {
  return WorkRepositoryImpl(ref.read(workDataSourceProvider));
});

final workProvider =
    StateNotifierProvider<WorkNotifier, AsyncValue<List<WorkEntity>>>((ref) {
      return WorkNotifier(ref.read(workRepositoryProvider));
    });

class WorkNotifier extends StateNotifier<AsyncValue<List<WorkEntity>>> {
  final WorkRepository repository;

  WorkNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchWorks();
  }

  Future<void> fetchWorks() async {
    try {
      state = const AsyncValue.loading();
      final works = await repository.getWorks();
      state = AsyncValue.data(works);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addWork(WorkEntity work) async {
    try {
      await repository.createWork(work);
      await fetchWorks();
    } catch (e) {
      throw Exception('Error al guardar el trabajo: $e');
    }
  }

  Future<void> updateWorkStatus(int workId, WorkState newState) async {
    try {
      // Optimistic Update: Actualizamos la UI inmediatamente para que sea fluido
      if (state is AsyncData) {
        final currentWorks = state.value!;
        final newWorks = currentWorks.map((w) {
          if (w.id == workId) {
            return WorkEntity(
              id: w.id,
              creationDate: w.creationDate,
              deadline: w.deadline,
              client: w.client,
              items: w.items,
              actualState: newState, // Estado optimista
            );
          }
          return w;
        }).toList();
        state = AsyncValue.data(newWorks);
      }

      await repository.updateWorkState(workId, newState);
      await fetchWorks(); // Re-sincronizamos con DB por seguridad
    } catch (e) {
      await fetchWorks(); // Rollback en UI si falla
      throw Exception('Error al actualizar el estado: $e');
    }
  }

  Future<void> toggleItemDone(int itemId, bool isDone) async {
    try {
      await repository.updateWorkItemDone(itemId, isDone);
      await fetchWorks(); // Recargamos para reflejar cambios en toda la app
    } catch (e) {
      throw Exception('Error al actualizar el ítem: $e');
    }
  }
}
