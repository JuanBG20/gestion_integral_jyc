enum Role {
  admin('ADMINISTRADOR'),
  operario('OPERARIO');

  final String dbValue;

  const Role(this.dbValue);

  static Role fromDB(String value) {
    return Role.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => Role.operario,
    );
  }
}
