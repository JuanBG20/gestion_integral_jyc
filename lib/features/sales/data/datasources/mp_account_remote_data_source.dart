import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_account_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MpAccountRemoteDataSource {
  final SupabaseClient supabaseClient;

  MpAccountRemoteDataSource(this.supabaseClient);

  Future<MpAccountEntity> getStatus() async {
    try {
      final response = await supabaseClient.rpc('mp_estado_conexion');
      final rows = response as List<dynamic>;
      if (rows.isEmpty) return const MpAccountEntity.disconnected();

      final row = rows.first as Map<String, dynamic>;
      final lastSync = row['ultimo_sync'] as String?;

      return MpAccountEntity(
        isConnected: row['conectada'] as bool? ?? false,
        nickname: row['nickname'] as String?,
        needsReconnection: row['estado'] == 'requiere_reconexion',
        lastSync: lastSync != null ? DateTime.parse(lastSync).toLocal() : null,
      );
    } catch (e) {
      throw Exception('Error al obtener la conexión con Mercado Pago: $e');
    }
  }

  Future<String> getAuthorizationUrl() async {
    final response = await supabaseClient.functions.invoke('mp-oauth-start');
    final data = response.data;

    if (response.status != 200 || data is! Map || data['url'] == null) {
      final error = data is Map ? data['error'] : null;
      throw Exception(error ?? 'No se pudo iniciar la conexión');
    }

    return data['url'] as String;
  }

  Future<void> disconnect() async {
    try {
      await supabaseClient.rpc('mp_desconectar');
    } catch (e) {
      throw Exception('Error al desconectar Mercado Pago: $e');
    }
  }
}
