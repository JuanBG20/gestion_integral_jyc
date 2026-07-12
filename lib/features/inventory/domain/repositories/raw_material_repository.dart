import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';

abstract class RawMaterialRepository {
  Future<List<RawMaterialEntity>> getRawMaterials();
  Future<void> createRawMaterial(RawMaterialEntity material);
  Future<void> updateRawMaterial(RawMaterialEntity material);
  Future<void> deleteRawMaterial(int id);
  Future<void> updateStock(int id, double delta);
}
