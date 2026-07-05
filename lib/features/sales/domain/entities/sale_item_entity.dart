import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class SaleItemEntity {
  final int? id;
  final VariantProductEntity? variantProduct;
  final int quantity;
  final double unitPrice;
  final String? description;

  SaleItemEntity({
    this.variantProduct,
    required this.quantity,
    required this.unitPrice,
    this.description,
    this.id,
  });

  double get subtotal => quantity * unitPrice;
}
