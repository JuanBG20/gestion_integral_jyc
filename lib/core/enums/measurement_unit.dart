enum MeasurementUnit {
  unidad('UNIDAD', 'Unidad'),
  gramos('GRAMOS', 'Gramos'),
  cm2('CM2', 'cm²');

  final String dbValue;
  final String label;

  const MeasurementUnit(this.dbValue, this.label);

  static MeasurementUnit fromDB(String value) {
    return MeasurementUnit.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => MeasurementUnit.unidad,
    );
  }
}
