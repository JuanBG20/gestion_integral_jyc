import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    required super.idAuth,
    required super.name,
    required super.lastName,
    required super.roles,
    super.isPremium = false,
    super.premiumExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rolUsuarioList = json['rol_usuario'] as List<dynamic>? ?? [];

    final roles = rolUsuarioList
        .map((ru) => Role.fromDB(ru['rol']?['nombre']))
        .whereType<Role>()
        .toList();

    DateTime? expiracion;
    if (json['fecha_expiracion_premium'] != null) {
      expiracion = DateTime.parse(
        json['fecha_expiracion_premium'] as String,
      ).toUtc();
    }

    return UserModel(
      id: json['idusuario'],
      idAuth: json['id_auth'],
      name: json['nombre'],
      lastName: json['apellido'],
      roles: roles,
      isPremium: json['es_premium'] as bool? ?? false,
      premiumExpiresAt: expiracion,
    );
  }
}
