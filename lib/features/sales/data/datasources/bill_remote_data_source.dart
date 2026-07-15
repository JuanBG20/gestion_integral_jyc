import 'package:supabase_flutter/supabase_flutter.dart';

class BillRemoteDataSource {
  final SupabaseClient supabaseClient;

  BillRemoteDataSource(this.supabaseClient);

  // TODO: Concepto Hardcodeado
  Future<void> emitInvoice({
    required int saleId,
    required int condicionIvaReceptorId,
    int concepto = 1,
  }) async {
    final response = await supabaseClient.functions.invoke(
      'emitir-factura-arca',
      body: {
        'ventaId': saleId,
        'concepto': concepto,
        'condicionIvaReceptorId': condicionIvaReceptorId,
      },
    );

    if (response.status != 200) {
      final error = response.data is Map
          ? (response.data['error'] ?? 'Error desconocido al facturar')
          : 'Error desconocido al facturar';
      throw Exception(error);
    }
  }
}
