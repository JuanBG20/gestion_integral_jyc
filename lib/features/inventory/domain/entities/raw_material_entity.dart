import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';

class RawMaterialEntity {
  final int? id;
  final String sku;
  final double stock;
  final String category;
  final String subcategory;
  final String description;
  final double minStock;
  final MeasurementUnit measurementUnit;
  final double unitPrice;

  RawMaterialEntity({
    required this.sku,
    required this.stock,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.minStock,
    this.id,
    this.measurementUnit = MeasurementUnit.unidad,
    required this.unitPrice,
  });

  String get fullCategory => '$category > $subcategory';

  String get formattedStock => _formatQuantity(stock);
  String get formattedMinStock => _formatQuantity(minStock);

  String _formatQuantity(double value) {
    switch (measurementUnit) {
      case MeasurementUnit.unidad:
        return '${value.round()} u.';
      case MeasurementUnit.gramos:
        return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} g';
      case MeasurementUnit.cm2:
        return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} cm²';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawMaterialEntity &&
          runtimeType == other.runtimeType &&
          id != null &&
          id == other.id;

  @override
  int get hashCode => id?.hashCode ?? identityHashCode(this);
}
