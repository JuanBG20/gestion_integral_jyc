class PricePreviewEntity {
  final int variantId;
  final String baseSku;
  final String variantSku;
  final String description;
  final double costPrice;
  final double actualSalePrice;
  final double suggestedSalePrice;

  PricePreviewEntity({
    required this.variantId,
    required this.baseSku,
    required this.variantSku,
    required this.description,
    required this.costPrice,
    required this.actualSalePrice,
    required this.suggestedSalePrice,
  });
}
