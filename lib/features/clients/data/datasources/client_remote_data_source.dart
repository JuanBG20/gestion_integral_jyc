import 'package:gestion_integral_jyc/features/clients/data/models/client_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRemoteDataSource {
  final SupabaseClient supabaseClient;

  ClientRemoteDataSource(this.supabaseClient);

  Future<List<ClientModel>> fetchClients() async {
    final response = await supabaseClient.from('cliente').select();
    return (response as List)
        .map((json) => ClientModel.fromJson(json))
        .toList();
  }

  Future<ClientModel> fetchClientById(int id) async {
    final response = await supabaseClient
        .from('cliente')
        .select()
        .eq('idcliente', id)
        .single();
    return ClientModel.fromJson(response);
  }

  Future<void> insertClient(ClientModel client) async {
    await supabaseClient.from('cliente').insert(client.toJson());
  }

  Future<void> updateClient(ClientModel client) async {
    if (client.id == null) throw Exception('El ID del cliente es nulo');
    await supabaseClient
        .from('cliente')
        .update(client.toJson())
        .eq('idcliente', client.id!);
  }

  Future<void> deleteClient(int id) async {
    await supabaseClient.from('cliente').delete().eq('idcliente', id);
  }
}
