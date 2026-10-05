import 'package:gestion_integral_jyc/features/reports/domain/entities/category_profitability_item_entity.dart';

class CategoryProfitabilityModel extends CategoryProfitabilityItemEntity {
  const CategoryProfitabilityModel({
    required super.category,
    required super.totalSales,
    required super.supplyCosts,
    required super.netProfit,
    required super.marginPercent,
    required super.utilityDistributionPercent,
  });

  factory CategoryProfitabilityModel.fromJson(Map<String, dynamic> json) {
    return CategoryProfitabilityModel(
      category: json['category'] ?? '',
      totalSales: json['total_sales']?.toString() ?? '\$0',
      supplyCosts: json['supply_costs']?.toString() ?? '\$0',
      netProfit: json['net_profit']?.toString() ?? '\$0',
      marginPercent: (json['margin_percent'] as num?)?.toDouble() ?? 0.0,
      utilityDistributionPercent:
          (json['utility_distribution_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
