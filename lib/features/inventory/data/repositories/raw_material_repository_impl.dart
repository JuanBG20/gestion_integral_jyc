import 'package:gestion_integral_jyc/features/inventory/data/datasources/raw_material_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/raw_material_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/raw_material_repository.dart';

class RawMaterialRepositoryImpl implements RawMaterialRepository {
  final RawMaterialRemoteDataSource remoteDataSource;

  RawMaterialRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createRawMaterial(RawMaterialEntity material) async {
    final model = RawMaterialModel(
      sku: material.sku,
      stock: material.stock,
      category: material.category,
      subcategory: material.subcategory,
      description: material.description,
      minStock: material.minStock,
      measurementUnit: material.measurementUnit,
      unitPrice: material.unitPrice,
    );
    await remoteDataSource.insertRawMaterial(model);
  }

  @override
  Future<void> deleteRawMaterial(int id) async {
    await remoteDataSource.deleteRawMaterial(id);
  }

  @override
  Future<List<RawMaterialEntity>> getRawMaterials() async {
    return await remoteDataSource.fetchRawMaterials();
  }

  @override
  Future<void> updateRawMaterial(RawMaterialEntity material) async {
    final model = RawMaterialModel(
      id: material.id,
      sku: material.sku,
      stock: material.stock,
      category: material.category,
      subcategory: material.subcategory,
      description: material.description,
      minStock: material.minStock,
      measurementUnit: material.measurementUnit,
      unitPrice: material.unitPrice,
    );
    await remoteDataSource.updateRawMaterial(model);
  }

  @override
  Future<void> updateStock(int id, double delta) async {
    await remoteDataSource.updateStock(id, delta);
  }
}
