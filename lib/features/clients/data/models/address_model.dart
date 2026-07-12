import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/enums/provincia.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    super.street,
    super.number,
    super.floor,
    super.apartment,
    super.location,
    super.province,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['calle'],
      number: json['numero'],
      floor: json['piso'],
      apartment: json['departamento'],
      location: json['localidad'],
      province: Provincia.fromDB(json['provincia']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calle': street,
      'numero': number,
      'piso': floor,
      'departamento': apartment,
      'localidad': location,
      'provincia': province?.dbValue,
    };
  }
}
