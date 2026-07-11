import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/inventory/data/datasources/raw_material_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/inventory/data/repositories/raw_material_repository_impl.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/repositories/raw_material_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final rawMaterialRemoteDataSourceProvider =
    Provider<RawMaterialRemoteDataSource>((ref) {
      return RawMaterialRemoteDataSource(Supabase.instance.client);
    });

final rawMaterialRepositoryProvider = Provider<RawMaterialRepository>((ref) {
  return RawMaterialRepositoryImpl(
    ref.read(rawMaterialRemoteDataSourceProvider),
  );
});

final rawMaterialProvider =
    StateNotifierProvider<
      RawMaterialNotifier,
      AsyncValue<List<RawMaterialEntity>>
    >((ref) {
      return RawMaterialNotifier(ref.read(rawMaterialRepositoryProvider));
    });

class RawMaterialNotifier
    extends StateNotifier<AsyncValue<List<RawMaterialEntity>>> {
  final RawMaterialRepository repository;

  RawMaterialNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchRawMaterials();
  }

  Future<void> fetchRawMaterials() async {
    try {
      state = const AsyncValue.loading();
      final materials = await repository.getRawMaterials();
      state = AsyncValue.data(materials);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addRawMaterial(RawMaterialEntity material) async {
    try {
      await repository.createRawMaterial(material);
      await fetchRawMaterials();
    } catch (e) {
      throw Exception('Error al guardar materia prima: $e');
    }
  }

  Future<void> removeRawMaterial(int id) async {
    try {
      await repository.deleteRawMaterial(id);
      await fetchRawMaterials();
    } catch (e) {
      throw Exception('Error al eliminar materia prima: $e');
    }
  }

  Future<void> updateStock(int id, int delta) async {
    await repository.updateStock(id, delta);
    await fetchRawMaterials();
  }
}
