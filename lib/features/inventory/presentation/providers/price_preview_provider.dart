import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/inventory/data/datasources/price_preview_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/repositories/price_preview_repository_impl.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/price_preview_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/price_preview_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final pricePreviewRemoteDataSourceProvider =
    Provider<PricePreviewRemoteDataSource>((ref) {
      return PricePreviewRemoteDataSource(Supabase.instance.client);
    });

final pricePreviewRepositoryProvider = Provider<PricePreviewRepository>((ref) {
  return PricePreviewRepositoryImpl(
    ref.read(pricePreviewRemoteDataSourceProvider),
  );
});

final pricePreviewProvider =
    StateNotifierProvider<
      PricePreviewNotifier,
      AsyncValue<List<PricePreviewEntity>>
    >((ref) {
      return PricePreviewNotifier(ref.read(pricePreviewRepositoryProvider));
    });

class PricePreviewNotifier
    extends StateNotifier<AsyncValue<List<PricePreviewEntity>>> {
  final PricePreviewRepository repository;

  PricePreviewNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchPricePreview();
  }

  Future<void> fetchPricePreview() async {
    try {
      state = const AsyncValue.loading();
      final pricePreviews = await repository.getPricePreview();
      state = AsyncValue.data(pricePreviews);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> confirmNewPrices(List<int> ids) async {
    try {
      state = const AsyncValue.loading();
      await repository.confirmNewPrice(ids);
      await fetchPricePreview();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
