import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';

class ScrapEntity {
  final double height;
  final double width;
  final RawMaterialEntity rawMaterial;

  ScrapEntity({
    required this.height,
    required this.width,
    required this.rawMaterial,
  });
}
