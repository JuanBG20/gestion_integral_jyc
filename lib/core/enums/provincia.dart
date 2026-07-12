enum Provincia {
  buenosAires('BUENOS AIRES', 'Buenos Aires'),
  caba('CABA', 'CABA'),
  catamarca('CATAMARCA', 'Catamarca'),
  chaco('CHACO', 'Chaco'),
  chubut('CHUBUT', 'Chubut'),
  cordoba('CORDOBA', 'Córdoba'),
  corrientes('CORRIENTES', 'Corrientes'),
  entreRios('ENTRE RIOS', 'Entre Ríos'),
  formosa('FORMOSA', 'Formosa'),
  jujuy('JUJUY', 'Jujuy'),
  laPampa('LA PAMPA', 'La Pampa'),
  laRioja('LA RIOJA', 'La Rioja'),
  mendoza('MENDOZA', 'Mendoza'),
  misiones('MISIONES', 'Misiones'),
  neuquen('NEUQUEN', 'Neuquén'),
  rioNegro('RIO NEGRO', 'Río Negro'),
  salta('SALTA', 'Salta'),
  sanJuan('SAN JUAN', 'San Juan'),
  sanLuis('SAN LUIS', 'San Luis'),
  santaCruz('SANTA CRUZ', 'Santa Cruz'),
  santaFe('SANTA FE', 'Santa Fe'),
  santiagoDelEstero('SANTIAGO DEL ESTERO', 'Santiago del Estero'),
  tierraDelFuego('TIERRA DEL FUEGO', 'Tierra del Fuego'),
  tucuman('TUCUMAN', 'Tucumán');

  final String dbValue;
  final String label;

  const Provincia(this.dbValue, this.label);

  static Provincia? fromDB(String? value) {
    if (value == null) return null;

    for (final provincia in Provincia.values) {
      if (provincia.dbValue == value) return provincia;
    }
    return null;
  }
}
