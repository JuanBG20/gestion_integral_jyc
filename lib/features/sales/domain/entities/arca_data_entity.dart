class ArcaDataEntity {
  final String cae;
  final DateTime caeVencimiento;
  final double impTotal;
  final int ptoVta;
  final int cbteTipo;
  final int cbteNro;
  final int docTipo;
  final int docNro;
  final int condicionIvaReceptorId;

  ArcaDataEntity({
    required this.cae,
    required this.caeVencimiento,
    required this.impTotal,
    required this.ptoVta,
    required this.cbteTipo,
    required this.cbteNro,
    required this.docTipo,
    required this.docNro,
    required this.condicionIvaReceptorId,
  });
}
