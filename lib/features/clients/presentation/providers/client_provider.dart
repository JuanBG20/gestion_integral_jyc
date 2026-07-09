import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/clients/data/datasources/client_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/clients/data/repositories/client_repository_impl.dart';
import 'package:gestion_integral_jyc/features/clients/domain/repositories/client_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final clientRemoteDataSourceProvider = Provider<ClientRemoteDataSource>((ref) {
  return ClientRemoteDataSource(Supabase.instance.client);
});

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepositoryImpl(ref.read(clientRemoteDataSourceProvider));
});

final clientProvider =
    StateNotifierProvider<ClientNotifier, AsyncValue<List<ClientEntity>>>((
      ref,
    ) {
      return ClientNotifier(ref.read(clientRepositoryProvider));
    });

class ClientNotifier extends StateNotifier<AsyncValue<List<ClientEntity>>> {
  final ClientRepository repository;

  ClientNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      state = const AsyncValue.loading();
      final clients = await repository.getClients();
      state = AsyncValue.data(clients);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addClient(ClientEntity client) async {
    try {
      await repository.createClient(client);
      await fetchClients(); // Refrescar la lista
    } catch (e) {
      throw Exception('Error al guardar el cliente: $e');
    }
  }

  Future<void> removeClient(int id) async {
    try {
      await repository.deleteClient(id);
      await fetchClients(); // Refrescar la lista
    } catch (e) {
      throw Exception('Error al eliminar el cliente: $e');
    }
  }
}
