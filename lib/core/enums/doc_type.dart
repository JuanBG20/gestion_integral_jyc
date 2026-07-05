enum DocType {
  dni('DNI'),
  cuil('CUIL'),
  cuit('CUIT');

  final String dbValue;

  const DocType(this.dbValue);

  static DocType fromDB(String value) {
    return DocType.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => DocType.dni,
    );
  }
}
