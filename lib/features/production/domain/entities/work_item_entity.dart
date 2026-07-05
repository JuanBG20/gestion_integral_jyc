import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';

class WorkItemEntity {
  final int? id;
  final VariantProductEntity? variantProduct;
  final int quantity;
  final double unitPrice;
  final bool isDone;
  final String? description;

  WorkItemEntity({
    this.variantProduct,
    required this.quantity,
    required this.unitPrice,
    this.isDone = false,
    this.description,
    this.id,
  });

  double get subtotal => quantity * unitPrice;
}
