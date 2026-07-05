enum WorkState {
  recibido('RECIBIDO'),
  disenado('DISEÑADO'),
  hecho('HECHO'),
  notificado('NOTIFICADO'),
  finalizado('FINALIZADO');

  final String dbValue;

  const WorkState(this.dbValue);

  static WorkState fromDB(String value) {
    return WorkState.values.firstWhere(
      (actualEnum) => actualEnum.dbValue == value,
      orElse: () => WorkState.recibido,
    );
  }
}
