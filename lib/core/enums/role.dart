enum Role {
  operario('OPERARIO', 'Operario'),
  administrador('ADMINISTRADOR', 'Administrador');

  final String dbValue;
  final String label;

  const Role(this.dbValue, this.label);

  static Role? fromDB(String? value) {
    if (value == null) return null;
    for (final r in Role.values) {
      if (r.dbValue == value) return r;
    }
    return null;
  }
}
