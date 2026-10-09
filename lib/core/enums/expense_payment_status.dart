enum ExpensePaymentStatus {
  pendiente('PENDIENTE'),
  pagado('PAGADO');

  final String dbValue;

  const ExpensePaymentStatus(this.dbValue);

  static ExpensePaymentStatus fromDB(String value) {
    return ExpensePaymentStatus.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => ExpensePaymentStatus.pendiente,
    );
  }
}
