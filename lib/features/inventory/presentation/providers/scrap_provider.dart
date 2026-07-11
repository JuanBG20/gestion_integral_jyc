import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
      return ScrapNotifier(ref.read(scrapRepositoryProvider));
    });

class ScrapNotifier extends StateNotifier<AsyncValue<List<ScrapEntity>>> {
  final ScrapRepository repository;

  ScrapNotifier(this.repository) : super(const AsyncValue.loading()) {
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
    } catch (e) {
      throw Exception('Error al guardar el retazo: $e');
    }
  }
}
