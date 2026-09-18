import 'package:gestion_integral_jyc/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<void> deleteAccount() async {
    await userRemoteDataSource.deleteAccount();
  }
}
