enum PaymentMethod {
  efectivo('EFECTIVO'),
  transferencia('TRANSFERENCIA'),
  qr('QR'),
  tarjeta('TARJETA');

  final String dbValue;

  const PaymentMethod(this.dbValue);

  static PaymentMethod fromDB(String value) {
    return PaymentMethod.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => PaymentMethod.efectivo,
    );
  }
}
