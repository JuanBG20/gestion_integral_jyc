import 'package:gestion_integral_jyc/features/inventory/data/models/base_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/variant_product_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';

class SaleItemModel extends SaleItemEntity {
  SaleItemModel({
    super.id,
    super.variantProduct,
    required super.quantity,
    required super.unitPrice,
    super.description,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    VariantProductModel? variantModel;
    if (json['producto_variante'] != null && json['producto_variante'] is Map) {
      final varJson = json['producto_variante'];
      if (varJson['producto_base'] != null) {
        final baseModel = BaseProductModel.fromJson(varJson['producto_base']);
        variantModel = VariantProductModel.fromJson(varJson, baseModel);
      }
    }

    return SaleItemModel(
      id: json['idcontiene_venta'],
      variantProduct: variantModel,
      quantity: json['cantidad'] ?? 0,
      unitPrice: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      description: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idcontiene_venta': id,
      'producto_variante': variantProduct?.id,
      'cantidad': quantity,
      'precio_unitario': unitPrice,
      'descripcion': description,
    };
  }
}
