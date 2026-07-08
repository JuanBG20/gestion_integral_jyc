import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';

class ClientEntity {
  final int? id;
  final String name;
  final String lastName;
  final String? additionalNotes;
  final DocType? docType;
  final String? docNumber;
  final String? email;
  final String? phoneNumber;
  final AddressEntity? address;

  ClientEntity({
    required this.name,
    required this.lastName,
    this.additionalNotes,
    this.docType,
    this.docNumber,
    this.email,
    this.phoneNumber,
    this.address,
    this.id,
  });

  String get fullName => '$name $lastName';
}
