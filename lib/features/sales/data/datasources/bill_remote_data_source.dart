import 'package:supabase_flutter/supabase_flutter.dart';

class BillRemoteDataSource {
  final SupabaseClient supabaseClient;

  BillRemoteDataSource(this.supabaseClient);

  Future<void> emitInvoice({
    required int saleId,
    required int condicionIvaReceptorId,
    required DateTime issueDate,
    int concepto = 1,
  }) async {
    final fecha =
        '${issueDate.year.toString().padLeft(4, '0')}'
        '${issueDate.month.toString().padLeft(2, '0')}'
        '${issueDate.day.toString().padLeft(2, '0')}';

    final response = await supabaseClient.functions.invoke(
      'emitir-factura-arca',
      body: {
        'ventaId': saleId,
        'concepto': concepto,
        'condicionIvaReceptorId': condicionIvaReceptorId,
        'fecha': fecha,
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
