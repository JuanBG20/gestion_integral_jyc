import 'package:gestion_integral_jyc/features/inventory/data/datasources/price_preview_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/price_preview_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/price_preview_repository.dart';

class PricePreviewRepositoryImpl extends PricePreviewRepository {
  final PricePreviewRemoteDataSource remoteDataSource;

  PricePreviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> confirmNewPrice(List<int> ids) async {
    await remoteDataSource.confirmNewPrice(ids);
  }

  @override
  Future<List<PricePreviewEntity>> getPricePreview() async {
    return await remoteDataSource.fetchPricePreview();
  }
}
