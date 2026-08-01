import 'package:gestion_integral_jyc/features/inventory/data/models/price_preview_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PricePreviewRemoteDataSource {
  final SupabaseClient supabaseClient;

  PricePreviewRemoteDataSource(this.supabaseClient);

  Future<List<PricePreviewModel>> fetchPricePreview() async {
    final response = await supabaseClient
        .from('vista_previsualizacion_precios')
        .select()
        .eq('requiere_actualizacion', true);
    return (response as List)
        .map((json) => PricePreviewModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> confirmNewPrice(List<int> ids) async {
    await supabaseClient.rpc(
      'actualizar_precios_masivos',
      params: {'ids_variantes': ids},
    );
  }
}
