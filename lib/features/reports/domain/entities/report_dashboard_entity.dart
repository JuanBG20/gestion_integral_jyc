import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/category_profitability_item_entity.dart';

class ReportDashboardEntity {
  final double totalInvoiced;
  final int activeOrders;
  final int pendingDesignOrders;
  final int stockAlerts;
  final double netProfit;
  final double globalMargin;
  final double pendingCollection;

  // Balance Mensual
  final double monthlyCollected;
  final double monthlyExpenses;
  final double monthlyFinalAmount;

  // Desglose
  final List<CategoryProfitabilityItemEntity> profitabilityByCategory;
  final List<BreakdownRowItemEntity> incomeByPaymentMethod;
  final List<BreakdownRowItemEntity> appliedDiscounts;
  final List<BreakdownRowItemEntity> registeredExpenses;

  ReportDashboardEntity({
    required this.totalInvoiced,
    required this.activeOrders,
    required this.pendingDesignOrders,
    required this.stockAlerts,
    required this.netProfit,
    required this.globalMargin,
    required this.monthlyCollected,
    required this.monthlyExpenses,
    required this.monthlyFinalAmount,
    required this.profitabilityByCategory,
    required this.incomeByPaymentMethod,
    required this.appliedDiscounts,
    required this.registeredExpenses,
    required this.pendingCollection,
  });
}
