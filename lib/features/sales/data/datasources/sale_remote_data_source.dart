import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaleRemoteDataSource {
  final SupabaseClient supabaseClient;

  SaleRemoteDataSource(this.supabaseClient);

  Future<List<SaleModel>> fetchSales() async {
    final response = await supabaseClient
        .from('venta')
        .select('''
      *,
      cliente (*),
      venta_trabajo (
        trabajo (*)
      ),
      contiene_venta (
        *,
        producto_variante (
          *,
          producto_base (*)
        )
      )
    ''')
        .order('fecha', ascending: false);

    return (response as List).map((json) => SaleModel.fromJson(json)).toList();
  }

  Future<void> createSaleRPC(
    SaleModel sale, {
    int? materiaPrimaId,
    double? consumo,
  }) async {
    final payload = {
      'p_cliente': sale.client.id,
      'p_metodo_pago': sale.paymentMethod.dbValue,
      'p_monto_total': sale.finalAmount,
      'p_id_trabajo': sale.work?.id,
      'p_items': sale.items
          .map((item) => (item as SaleItemModel).toJson())
          .toList(),
      'p_materia_prima': materiaPrimaId,
      'p_consumo': consumo,
    };

    await supabaseClient.rpc('crear_venta_completa', params: payload);
  }
}
