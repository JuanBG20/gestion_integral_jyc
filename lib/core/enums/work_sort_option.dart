enum WorkSortOption {
  creationDesc('Más recientes primero'),
  creationAsc('Más antiguos primero'),
  deadlineAsc('Próximos a vencer'),
  deadlineDesc('Vencimientos lejanos');

  final String label;
  const WorkSortOption(this.label);
}
