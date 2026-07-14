enum CondicionIvaReceptor {
  responsableInscripto(1, 'Responsable Inscripto'),
  monotributo(6, 'Responsable Monotributo'),
  monotributoSocial(13, 'Monotributista Social'),
  monotributoPromovido(16, 'Monotributo Trabajador Independiente Promovido'),
  exento(4, 'IVA Sujeto Exento'),
  consumidorFinal(5, 'Consumidor Final'),
  noCategorizado(7, 'Sujeto No Categorizado'),
  proveedorExterior(8, 'Proveedor del Exterior'),
  clienteExterior(9, 'Cliente del Exterior'),
  liberadoLey19640(10, 'IVA Liberado – Ley N° 19.640'),
  noAlcanzado(15, 'IVA No Alcanzado');

  final int arcaId;
  final String label;

  const CondicionIvaReceptor(this.arcaId, this.label);
}
