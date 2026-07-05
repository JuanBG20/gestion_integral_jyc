import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';

class MaterialRecipeEntity {
  final RawMaterialEntity rawMaterial;
  final double quantity;

  MaterialRecipeEntity({required this.rawMaterial, required this.quantity});
}
