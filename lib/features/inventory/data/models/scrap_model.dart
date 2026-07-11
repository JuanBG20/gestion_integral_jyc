import 'package:gestion_integral_jyc/features/inventory/data/models/raw_material_model.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';

class ScrapModel extends ScrapEntity {
  ScrapModel({
    super.id,
    required super.height,
    required super.width,
    required super.rawMaterial,
    required super.stock,
  });

  factory ScrapModel.fromJson(Map<String, dynamic> json) {
    return ScrapModel(
      id: json['idretazo'],
      width: (json['ancho'] as num).toDouble(),
      height: (json['alto'] as num).toDouble(),
      stock: json['stock'],
      // Supabase nos traerá la materia prima anidada gracias al JOIN
      rawMaterial: RawMaterialModel.fromJson(json['materia_prima']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idretazo': id,
      'ancho': width,
      'alto': height,
      'stock': stock,
      'materia_prima': rawMaterial.id,
    };
  }
}
