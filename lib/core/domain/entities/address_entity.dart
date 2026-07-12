import 'package:gestion_integral_jyc/core/enums/provincia.dart';

class AddressEntity {
  final String? street;
  final String? number;
  final String? location;
  final Provincia? province;
  final String? apartment;
  final String? floor;

  AddressEntity({
    this.street,
    this.number,
    this.location,
    this.province,
    this.apartment,
    this.floor,
  });

  bool get isEmpty =>
      street == null &&
      number == null &&
      location == null &&
      province == null &&
      apartment == null &&
      floor == null;
}
