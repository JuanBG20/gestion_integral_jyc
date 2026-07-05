class BaseProductEntity {
  final int? id;
  final String baseSku;
  final String category;
  final String subcategory;
  final String description;

  BaseProductEntity({
    required this.baseSku,
    required this.category,
    required this.subcategory,
    required this.description,
    this.id,
  });

  String get fullCategory => '$category > $subcategory';
}
