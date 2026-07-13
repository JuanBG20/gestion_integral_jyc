import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';

extension ClientDocumentFormatting on ClientEntity {
  String get formattedDocument {
    if (docType == null || docNumber == null) return "-";
    return '${docType!.dbValue} $docNumber';
  }
}

extension ClientContactFormatting on ClientEntity {
  bool get hasEmail => email != null;

  String get displayEmail => email ?? "No especificado";
  String get displayPhone => phoneNumber ?? "No especificado";
}

extension ClientNotesFormatting on ClientEntity {
  bool get hasNotes => additionalNotes != null && additionalNotes!.isNotEmpty;
}
