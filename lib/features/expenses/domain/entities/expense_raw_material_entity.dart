import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';

class ExpenseRawMaterialEntity {
  final int? id;
  final RawMaterialEntity rawMaterial;
  final double quantity;
  final double? unitPrice;

  ExpenseRawMaterialEntity({
    this.id,
    required this.rawMaterial,
    required this.quantity,
    this.unitPrice,
  });
}
