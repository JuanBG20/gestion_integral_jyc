import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class SaleItemEntity implements ProductLineItemEntity {
  final int? id;

  @override
  final VariantProductEntity? variantProduct;

  @override
  final int quantity;

  @override
  final double unitPrice;

  @override
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
