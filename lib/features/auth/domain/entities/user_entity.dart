import 'package:gestion_integral_jyc/core/enums/role.dart';

class UserEntity {
  final int? id;
  final String idAuth;
  final String name;
  final String lastName;
  final List<Role> roles;

  UserEntity({
    required this.idAuth,
    required this.name,
    required this.lastName,
    required this.roles,
    this.id,
  });

  String get fullName => '$name $lastName';

  bool hasRole(Role role) => roles.contains(role);
}
