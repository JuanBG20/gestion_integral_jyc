import 'package:supabase_flutter/supabase_flutter.dart';

class ReportRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportRemoteDataSource(this.supabaseClient);

  Future<Map<String, dynamic>> fetchDashboardMetrics() async {
    try {
      final response = await supabaseClient.rpc('obtener_metricas_reportes');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener métricas de reportes: $e');
    }
  }
}
