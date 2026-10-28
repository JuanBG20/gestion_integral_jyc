import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/domain/services/analytics_service.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/analytics_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/data/datasources/scrap_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/repositories/scrap_repository_impl.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/scrap_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final scrapDataSourceProvider = Provider<ScrapRemoteDataSource>((ref) {
  return ScrapRemoteDataSource(Supabase.instance.client);
});

final scrapRepositoryProvider = Provider<ScrapRepository>((ref) {
  return ScrapRepositoryImpl(ref.read(scrapDataSourceProvider));
});

final scrapProvider =
    StateNotifierProvider<ScrapNotifier, AsyncValue<List<ScrapEntity>>>((ref) {
      return ScrapNotifier(
        repository: ref.read(scrapRepositoryProvider),
        analytics: ref.read(analyticsProvider),
      );
    });

class ScrapNotifier extends StateNotifier<AsyncValue<List<ScrapEntity>>> {
  final ScrapRepository repository;
  final AnalyticsService analytics;

  ScrapNotifier({required this.repository, required this.analytics})
    : super(const AsyncValue.loading()) {
    fetchScraps();
  }

  Future<void> fetchScraps() async {
    try {
      state = const AsyncValue.loading();
      final scraps = await repository.getScraps();
      state = AsyncValue.data(scraps);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addScrap(ScrapEntity scrap) async {
    try {
      await repository.createScrap(scrap);
      await fetchScraps();

      await analytics.logScrapAdded();
    } catch (e) {
      throw Exception('Error al guardar el retazo: $e');
    }
  }

  Future<void> updateScrap(ScrapEntity scrap) async {
    try {
      await repository.updateScrap(scrap);
      await fetchScraps();
    } catch (e) {
      throw Exception('Error al actualizar el retazo: $e');
    }
  }

  Future<void> removeScrap(int id) async {
    try {
      await repository.deleteScrap(id);
      await fetchScraps();
    } catch (e) {
      throw Exception('Error al eliminar retazo: $e');
    }
  }

  Future<void> updateStock(int id, int delta) async {
    await repository.updateStock(id, delta);
    await fetchScraps();
  }
}
