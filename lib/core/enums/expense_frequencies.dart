enum ExpenseFrequencies {
  mensual('MENSUAL'),
  bimestral('BIMESTRAL'),
  anual('ANUAL'),
  semestral('SEMESTRAL'),
  semanal('SEMANAL'),
  quincenal('QUINCENAL');

  final String dbValue;

  const ExpenseFrequencies(this.dbValue);

  static ExpenseFrequencies fromDB(String value) {
    return ExpenseFrequencies.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => ExpenseFrequencies.mensual,
    );
  }
}
