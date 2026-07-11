import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';

abstract class ScrapRepository {
  Future<List<ScrapEntity>> getScraps();
  Future<void> createScrap(ScrapEntity scrap);
  Future<void> updateStock(int id, int delta);
}
