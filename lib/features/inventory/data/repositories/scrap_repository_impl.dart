import 'package:gestion_integral_jyc/features/inventory/data/datasources/scrap_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/scrap_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/scrap_repository.dart';

class ScrapRepositoryImpl implements ScrapRepository {
  final ScrapRemoteDataSource remoteDataSource;

  ScrapRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createScrap(ScrapEntity scrap) async {
    final model = ScrapModel(
      width: scrap.width,
      height: scrap.height,
      stock: scrap.stock,
      rawMaterial: scrap.rawMaterial,
    );
    await remoteDataSource.insertScrap(model);
  }

  @override
  Future<List<ScrapEntity>> getScraps() async {
    return await remoteDataSource.fetchScraps();
  }
}
