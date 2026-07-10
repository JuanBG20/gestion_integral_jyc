import 'package:gestion_integral_jyc/features/production/data/models/work_item_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkRemoteDataSource {
  final SupabaseClient supabaseClient;

  WorkRemoteDataSource(this.supabaseClient);

  Future<List<WorkModel>> fetchWorks() async {
    final response = await supabaseClient.from('trabajo').select('''
      *,
      cliente (*),
      historial_estado (
        fecha,
        estado (nombre)
      ),
      contiene_trabajo (
        *,
        producto_variante (
          *,
          producto_base (*)
        )
      )
    ''');

    return (response as List).map((json) => WorkModel.fromJson(json)).toList();
  }

  Future<void> createWorkRPC(WorkModel work) async {
    final payload = {
      'p_cliente': work.client.id,
      'p_fecha_limite': work.deadline?.toIso8601String(),
      'p_items': work.items
          .map((item) => (item as WorkItemModel).toJson())
          .toList(),
    };

    await supabaseClient.rpc('crear_trabajo_completo', params: payload);
  }

  Future<void> updateWorkStateRPC(int workId, String newStateStr) async {
    await supabaseClient.rpc(
      'actualizar_estado_trabajo',
      params: {'p_id_trabajo': workId, 'p_nuevo_estado': newStateStr},
    );
  }

  Future<void> updateItemDone(int itemId, bool isDone) async {
    await supabaseClient
        .from('contiene_trabajo')
        .update({'hecho': isDone})
        .eq('idcontiene_trabajo', itemId);
  }
}
