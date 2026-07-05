class RawMaterialEntity {
  final int? id;
  final String sku;
  final int stock;
  final String category;
  final String subcategory;
  final String description;
  final int minStock;

  RawMaterialEntity({
    required this.sku,
    required this.stock,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.minStock,
    this.id,
  });

  String get fullCategory => '$category > $subcategory';
}
