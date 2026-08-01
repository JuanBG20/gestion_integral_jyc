import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';

class PriceCalculator {
  static double toDisplayPrice(double dbPrice, MeasurementUnit unit) {
    if (unit == MeasurementUnit.gramos) {
      return dbPrice * 1000;
    }

    return dbPrice;
  }

  static double toDatabasePrice(double inputPrice, MeasurementUnit unit) {
    if (unit == MeasurementUnit.gramos) {
      return inputPrice / 1000;
    }

    return inputPrice;
  }
}
