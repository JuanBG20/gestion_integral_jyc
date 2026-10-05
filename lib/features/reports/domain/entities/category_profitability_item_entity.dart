class CategoryProfitabilityItemEntity {
  final String category;
  final String totalSales;
  final String supplyCosts;
  final String netProfit;
  final double marginPercent;
  final double utilityDistributionPercent;

  const CategoryProfitabilityItemEntity({
    required this.category,
    required this.totalSales,
    required this.supplyCosts,
    required this.netProfit,
    required this.marginPercent,
    required this.utilityDistributionPercent,
  });
}
