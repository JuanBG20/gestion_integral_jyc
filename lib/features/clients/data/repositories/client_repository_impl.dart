import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/clients/data/datasources/client_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/clients/data/models/client_model.dart';
import 'package:gestion_integral_jyc/features/clients/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createClient(ClientEntity client) async {
    try {
      final clientModel = ClientModel(
        name: client.name,
        lastName: client.lastName,
        additionalNotes: client.additionalNotes,
        docType: client.docType,
        docNumber: client.docNumber,
        email: client.email,
        phoneNumber: client.phoneNumber,
        address: client.address,
      );
      await remoteDataSource.insertClient(clientModel);
    } catch (e) {
      throw Exception('Error al crear el cliente: $e');
    }
  }

  @override
  Future<void> deleteClient(int id) async {
    try {
      await remoteDataSource.deleteClient(id);
    } catch (e) {
      throw Exception('Error al eliminar el cliente: $e');
    }
  }

  @override
  Future<ClientEntity> getClientById(int id) async {
    try {
      return await remoteDataSource.fetchClientById(id);
    } catch (e) {
      throw Exception('Error al obtener cliente: $e');
    }
  }

  @override
  Future<List<ClientEntity>> getClients() async {
    try {
      return await remoteDataSource.fetchClients();
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  @override
  Future<void> updateClient(ClientEntity client) async {
    try {
      final clientModel = ClientModel(
        id: client.id,
        name: client.name,
        lastName: client.lastName,
        additionalNotes: client.additionalNotes,
        docType: client.docType,
        docNumber: client.docNumber,
        email: client.email,
        phoneNumber: client.phoneNumber,
        address: client.address,
      );
      await remoteDataSource.insertClient(clientModel);
    } catch (e) {
      throw Exception('Error al actualizar el cliente: $e');
    }
  }
}
