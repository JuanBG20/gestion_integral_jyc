import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_account_entity.dart';

abstract class MpAccountRepository {
  Future<MpAccountEntity> getStatus();
  Future<String> getAuthorizationUrl();
  Future<void> disconnect();
}
