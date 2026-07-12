import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    required super.idAuth,
    required super.name,
    required super.lastName,
    required super.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rolUsuarioList = json['rol_usuario'] as List<dynamic>? ?? [];

    final roles = rolUsuarioList
        .map((ru) => Role.fromDB(ru['rol']?['nombre']))
        .whereType<Role>()
        .toList();

    return UserModel(
      id: json['idusuario'],
      idAuth: json['id_auth'],
      name: json['nombre'],
      lastName: json['apellido'],
      roles: roles,
    );
  }
}
