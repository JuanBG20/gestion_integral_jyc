import 'package:gestion_integral_jyc/features/inventory/data/models/scrap_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScrapRemoteDataSource {
  final SupabaseClient supabaseClient;

  ScrapRemoteDataSource(this.supabaseClient);

  Future<List<ScrapModel>> fetchScraps() async {
    final response = await supabaseClient.from('retazo').select('''
      *,
      materia_prima (*)
    ''');
    return (response as List).map((json) => ScrapModel.fromJson(json)).toList();
  }

  Future<void> insertScrap(ScrapModel scrap) async {
    await supabaseClient.rpc(
      'agregar_retazo',
      params: {
        'p_ancho': scrap.width,
        'p_alto': scrap.height,
        'p_stock': scrap.stock,
        'p_materia_prima': scrap.rawMaterial.id,
      },
    );
  }

  Future<void> updateStock(int id, int delta) async {
    await supabaseClient.rpc(
      'ajustar_stock_retazo',
      params: {'p_id': id, 'p_cantidad': delta},
    );
  }
}
