import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.street,
    required super.number,
    super.floor,
    super.apartment,
    required super.location,
    required super.province,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['calle'] ?? '',
      number: json['numero'] ?? '',
      floor: json['piso'],
      apartment: json['departamento'],
      location: json['localidad'] ?? '',
      province: json['provincia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calle': street,
      'numero': number,
      'piso': floor,
      'departamento': apartment,
      'localidad': location,
      'provincia': province,
    };
  }
}
