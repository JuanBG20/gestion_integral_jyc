import 'package:gestion_integral_jyc/features/inventory/domain/entities/price_preview_entity.dart';

class PricePreviewModel extends PricePreviewEntity {
  PricePreviewModel({
    required super.variantId,
    required super.baseSku,
    required super.variantSku,
    required super.description,
    required super.costPrice,
    required super.actualSalePrice,
    required super.suggestedSalePrice,
  });

  factory PricePreviewModel.fromJson(Map<String, dynamic> json) {
    return PricePreviewModel(
      variantId: json['idproducto_variante'],
      baseSku: json['sku_base'],
      variantSku: json['sku_variante'],
      description: json['descripcion'],
      costPrice: double.parse(json['precio_costo'].toString()),
      actualSalePrice: double.parse(json['precio_venta_actual'].toString()),
      suggestedSalePrice: double.parse(
        json['precio_venta_sugerido'].toString(),
      ),
    );
  }
}
