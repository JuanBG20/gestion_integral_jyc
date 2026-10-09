enum ExpenseAmountTypes {
  fijo('FIJO'),
  variable('VARIABLE');

  final String dbValue;

  const ExpenseAmountTypes(this.dbValue);

  static ExpenseAmountTypes fromDB(String value) {
    return ExpenseAmountTypes.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => ExpenseAmountTypes.fijo,
    );
  }
}
