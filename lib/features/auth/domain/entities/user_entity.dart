import 'package:gestion_integral_jyc/core/enums/role.dart';

class UserEntity {
  final int? id;
  final String idAuth;
  final String name;
  final String lastName;
  final Role role;

  UserEntity({
    required this.idAuth,
    required this.name,
    required this.lastName,
    required this.role,
    this.id,
  });

  String get fullName => '$name $lastName';
}
