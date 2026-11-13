import 'package:supabase_flutter/supabase_flutter.dart';

class ReportRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportRemoteDataSource(this.supabaseClient);

  Future<Map<String, dynamic>> fetchDashboardMetrics({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'obtener_metricas_reportes',
        params: {
          'p_desde': from.toUtc().toIso8601String(),
          'p_hasta': to.toUtc().toIso8601String(),
        },
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener métricas de reportes: $e');
    }
  }
}
