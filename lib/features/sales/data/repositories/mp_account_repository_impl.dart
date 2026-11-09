import 'package:gestion_integral_jyc/features/sales/data/datasources/mp_account_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_account_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/mp_account_repository.dart';

class MpAccountRepositoryImpl implements MpAccountRepository {
  final MpAccountRemoteDataSource remoteDataSource;

  MpAccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<MpAccountEntity> getStatus() => remoteDataSource.getStatus();

  @override
  Future<String> getAuthorizationUrl() =>
      remoteDataSource.getAuthorizationUrl();

  @override
  Future<void> disconnect() => remoteDataSource.disconnect();
}
