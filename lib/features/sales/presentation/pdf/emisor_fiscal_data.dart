import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmisorFiscalData {
  static String razonSocial = dotenv.env['RAZON_SOCIAL'] ?? '';
  static String cuit = dotenv.env['CUIT'] ?? '';
  static String domicilioComercial = dotenv.env['DOMICILIO_COMERCIAL'] ?? '';
  static String condicionIva = dotenv.env['CONDICION_IVA'] ?? '';
  static String ingresosBrutos = dotenv.env['CUIT'] ?? '';
  static String fechaInicioActividades =
      dotenv.env['FECHA_INICIO_ACTIVIDADES'] ?? '';
}
