import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';

abstract class ClientRepository {
  Future<List<ClientEntity>> getClients();
  Future<ClientEntity> getClientById(int id);
  Future<void> createClient(ClientEntity client);
  Future<void> updateClient(ClientEntity client);
  Future<void> deleteClient(int id);
}
