enum DiscountOrigin {
  metodoPago('METODO_PAGO', 'Método de Pago'),
  temporada('TEMPORADA', 'Temporada / Evento'),
  cantidad('CANTIDAD', 'Cantidad'),
  otro('OTRO', "Otro");

  final String dbValue;
  final String label;

  const DiscountOrigin(this.dbValue, this.label);

  factory DiscountOrigin.fromDB(String dbValue) {
    return DiscountOrigin.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => DiscountOrigin.otro,
    );
  }
}
