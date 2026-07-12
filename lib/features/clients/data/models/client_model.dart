import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/features/clients/data/models/address_model.dart';

class ClientModel extends ClientEntity {
  ClientModel({
    super.id,
    required super.name,
    required super.lastName,
    super.additionalNotes,
    super.docType,
    super.docNumber,
    super.email,
    super.phoneNumber,
    super.address,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final address = AddressModel.fromJson(json);

    return ClientModel(
      id: json['idcliente'],
      name: json['nombre'],
      lastName: json['apellido'],
      additionalNotes: json['notas_adicionales'],
      docType: DocType.fromDB(json['tipo_documento']),
      docNumber: json['num_documento'],
      email: json['correo'],
      phoneNumber: json['telefono'],
      address: address.isEmpty ? null : address,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      if (id != null) 'idcliente': id,
      'nombre': name,
      'apellido': lastName,
      'notas_adicionales': additionalNotes,
      'tipo_documento': docType?.dbValue,
      'num_documento': docNumber,
      'correo': email,
      'telefono': phoneNumber,
    };

    if (address != null) {
      final addressModel = AddressModel(
        street: address!.street,
        number: address!.number,
        floor: address!.floor,
        apartment: address!.apartment,
        location: address!.location,
        province: address!.province,
      );
      map.addAll(addressModel.toJson());
    }

    return map;
  }
}
