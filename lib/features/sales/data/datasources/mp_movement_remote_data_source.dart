import 'package:gestion_integral_jyc/features/sales/data/models/mp_movement_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MpMovementRemoteDataSource {
  final SupabaseClient supabaseClient;

  MpMovementRemoteDataSource(this.supabaseClient);

  // Ultimos 25 movimientos
  Future<List<MpMovementModel>> getMovements() async {
    try {
      final response = await supabaseClient
          .from('movimiento_mp')
          .select('*, mp_venta(venta)')
          .order('fecha', ascending: false)
          .limit(25);

      return (response as List<dynamic>)
          .map((json) => MpMovementModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener movimientos de Mercado Pago: $e');
    }
  }

  Future<void> linkToSale(int movementId, int saleId) async {
    try {
      await supabaseClient.from('mp_venta').insert({
        'movimiento_mp': movementId,
        'venta': saleId,
      });
    } catch (e) {
      throw Exception('Error al vincular movimiento a la venta: $e');
    }
  }
}
