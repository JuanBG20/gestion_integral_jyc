import 'package:gestion_integral_jyc/features/inventory/data/models/raw_material_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/material_recipe_entity.dart';

class MaterialRecipeModel extends MaterialRecipeEntity {
  MaterialRecipeModel({required super.rawMaterial, required super.quantity});

  factory MaterialRecipeModel.fromJson(Map<String, dynamic> json) {
    return MaterialRecipeModel(
      rawMaterial: RawMaterialModel.fromJson(
        json['materia_prima'] as Map<String, dynamic>? ?? {},
      ),
      quantity: (json['cantidad'] ?? 0).toDouble(),
    );
  }

  /* Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idretazo': id,
      'ancho': width,
      'alto': height,
      'stock': stock,
      'materia_prima': rawMaterial.id,
    };
  } */
}
