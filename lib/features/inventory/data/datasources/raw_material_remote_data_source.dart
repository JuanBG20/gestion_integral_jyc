import 'package:gestion_integral_jyc/features/inventory/data/models/raw_material_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RawMaterialRemoteDataSource {
  final SupabaseClient supabaseClient;

  RawMaterialRemoteDataSource(this.supabaseClient);

  Future<List<RawMaterialModel>> fetchRawMaterials() async {
    final response = await supabaseClient.from('materia_prima').select();
    return (response as List)
        .map((json) => RawMaterialModel.fromJson(json))
        .toList();
  }

  Future<void> insertRawMaterial(RawMaterialModel material) async {
    await supabaseClient.from('materia_prima').insert(material.toJson());
  }

  Future<void> updateRawMaterial(RawMaterialModel material) async {
    if (material.id == null) throw Exception('El ID es nulo');
    await supabaseClient
        .from('materia_prima')
        .update(material.toJson())
        .eq('idmateria_prima', material.id!);
  }

  Future<void> deleteRawMaterial(int id) async {
    await supabaseClient
        .from('materia_prima')
        .delete()
        .eq('idmateria_prima', id);
  }

  Future<void> updateStock(int id, int delta) async {
    await supabaseClient.rpc(
      'ajustar_stock_mp',
      params: {'p_id': id, 'p_cantidad': delta},
    );
  }
}
