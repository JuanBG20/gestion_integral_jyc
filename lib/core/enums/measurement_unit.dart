enum MeasurementUnit {
  unidad('UNIDAD', 'Unidad', 'u.'),
  gramos('GRAMOS', 'Gramos', 'g.'),
  cm2('CM2', 'cm²', 'cm²');

  final String dbValue;
  final String label;
  final String abbreviation;

  const MeasurementUnit(this.dbValue, this.label, this.abbreviation);

  static MeasurementUnit fromDB(String value) {
    return MeasurementUnit.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => MeasurementUnit.unidad,
    );
  }
}
