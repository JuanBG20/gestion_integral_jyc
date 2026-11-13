import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';

extension LineItemFormatting on ProductLineItemEntity {
  String get displayName =>
      variantProduct?.baseProduct.description ??
      description ??
      'Sin descripción';

  String? get variantLabel {
    final variant = variantProduct;
    if (variant == null) return null;

    final attributes = [variant.color, variant.size]
        .where((attr) => attr != null && attr.trim().isNotEmpty)
        .cast<String>()
        .toList();

    return attributes.isEmpty ? null : attributes.join(' / ');
  }

  String get searchableText {
    final variant = variantProduct;
    return [
      displayName,
      description,
      variant?.sku,
      variant?.baseProduct.fullCategory,
      variantLabel,
    ].whereType<String>().join(' ').toLowerCase();
  }
}
