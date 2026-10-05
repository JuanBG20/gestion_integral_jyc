import 'package:gestion_integral_jyc/features/reports/data/models/breakdown_row_model.dart';
import 'package:gestion_integral_jyc/features/reports/data/models/category_profitability_model.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';

class ReportDashboardModel extends ReportDashboardEntity {
  ReportDashboardModel({
    required super.totalInvoiced,
    required super.activeOrders,
    required super.pendingDesignOrders,
    required super.stockAlerts,
    required super.netProfit,
    required super.globalMargin,
    required super.monthlyCollected,
    required super.monthlyExpenses,
    required super.monthlyFinalAmount,
    required super.profitabilityByCategory,
    required super.incomeByPaymentMethod,
    required super.appliedDiscounts,
    required super.registeredExpenses,
    required super.pendingCollection,
  });

  factory ReportDashboardModel.fromJson(Map<String, dynamic> json) {
    return ReportDashboardModel(
      totalInvoiced: (json['total_invoiced'] as num?)?.toDouble() ?? 0.0,
      pendingCollection:
          (json['pending_collection'] as num?)?.toDouble() ?? 0.0,
      activeOrders: (json['active_orders'] as num?)?.toInt() ?? 0,
      pendingDesignOrders:
          (json['pending_design_orders'] as num?)?.toInt() ?? 0,
      stockAlerts: (json['stock_alerts'] as num?)?.toInt() ?? 0,
      netProfit: (json['net_profit'] as num?)?.toDouble() ?? 0.0,
      globalMargin: (json['global_margin'] as num?)?.toDouble() ?? 0.0,
      monthlyCollected: (json['monthly_collected'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (json['monthly_expenses'] as num?)?.toDouble() ?? 0.0,
      monthlyFinalAmount:
          (json['monthly_final_amount'] as num?)?.toDouble() ?? 0.0,

      profitabilityByCategory:
          (json['profitability_by_category'] as List<dynamic>? ?? [])
              .map((item) => CategoryProfitabilityModel.fromJson(item))
              .toList(),

      incomeByPaymentMethod:
          (json['income_by_payment_method'] as List<dynamic>? ?? [])
              .map((item) => BreakdownRowModel.fromJson(item))
              .toList(),

      appliedDiscounts: (json['applied_discounts'] as List<dynamic>? ?? [])
          .map((item) => BreakdownRowModel.fromJson(item))
          .toList(),

      registeredExpenses: (json['registered_expenses'] as List<dynamic>? ?? [])
          .map((item) => BreakdownRowModel.fromJson(item))
          .toList(),
    );
  }
}
