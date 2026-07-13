import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';

extension AddressFormatting on AddressEntity {
  String get formatted {
    final streetLine = [
      street,
      number,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    final floorAndApt = [
      floor,
      apartment,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    final parts = [
      if (streetLine.isNotEmpty) streetLine,
      if (floorAndApt.isNotEmpty) floorAndApt,
      if (location != null && location!.isNotEmpty) location!,
      if (province != null) province!.label,
    ];

    return parts.join(', ');
  }
}

extension ClientAddressFormatting on ClientEntity {
  String get formattedAddress => address?.formatted ?? 'Sin dirección';
}
