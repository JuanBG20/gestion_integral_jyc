enum DocType {
  dni('DNI'),
  cuil('CUIL'),
  cuit('CUIT');

  final String dbValue;

  const DocType(this.dbValue);

  static DocType? fromDB(String? value) {
    if (value == null) return null;

    for (final type in DocType.values) {
      if (type.dbValue == value) return type;
    }
    return null;
  }
}
