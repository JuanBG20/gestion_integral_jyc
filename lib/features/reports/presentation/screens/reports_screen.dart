import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/summary_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/providers/report_provider.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/applied_discounts_card.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/category_profitability_card.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/monthly_balance_card.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/payment_methods_card.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/registered_expenses_card.dart';
import 'package:go_router/go_router.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportMetricsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Reportes",
              subtitle:
                  "Métricas en tiempo real, ingresos netos y balance financiero por categoría.",
              buttonLabel: "Exportar Reporte",

              hasSecondaryButton: true,
              secondaryButtonLabel: "Este Mes",
              secondaryButtonIcon: Icons.calendar_month_outlined,

              hasButtons: true,
            ),

            const SizedBox(height: 32),

            reportState.when(
              data: (dashboard) => _buildDashboardContent(context, dashboard),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    ReportDashboardEntity dashboard,
  ) {
    final totalDiscounts = dashboard.appliedDiscounts.fold(0.0, (sum, item) {
      final cleanValue = item.trailingText.replaceAll(RegExp(r'[^\d.]'), '');
      return sum + (double.tryParse(cleanValue) ?? 0.0);
    });

    final totalExpenses = dashboard.registeredExpenses.fold(0.0, (sum, item) {
      final cleanValue = item.trailingText.replaceAll(RegExp(r'[^\d.]'), '');
      return sum + (double.tryParse(cleanValue) ?? 0.0);
    });

    final totalSupplyCosts = dashboard.profitabilityByCategory.fold(0.0, (
      sum,
      item,
    ) {
      final cleanValue = item.supplyCosts.replaceAll(RegExp(r'[^\d.]'), '');
      return sum + (double.tryParse(cleanValue) ?? 0.0);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 400
                ? constraints.maxWidth
                : (constraints.maxWidth / 2) - 8;

            return Wrap(
              spacing: 16,
              runSpacing: 16,

              children: [
                SummaryCard(
                  width: cardWidth,
                  title: 'FACTURACIÓN TOTAL',
                  value: '\$${dashboard.totalInvoiced.toStringAsFixed(0)}',
                  subtitle: dashboard.pendingCollection > 0
                      ? '\$${dashboard.pendingCollection.toStringAsFixed(0)} pendientes de cobro'
                      : 'Todo el mes cobrado',
                  icon: Icons.trending_up,
                  iconColor:
                      dashboard.pendingCollection >
                          (dashboard.totalInvoiced * 0.3)
                      ? Colors.orange
                      : Colors.green,
                  onTap: () => context.go('/sales'),
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ÓRDENES ACTIVAS',
                  value: '${dashboard.activeOrders}',
                  subtitle: '${dashboard.activeOrders} con diseño pendiente',
                  icon: Icons.precision_manufacturing_outlined,
                  iconColor: Colors.deepPurple,
                  onTap: () => context.go('/work'),
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ALERTAS DE STOCK DE MATERIA PRIMA',
                  value: '${dashboard.stockAlerts}',
                  subtitle: dashboard.stockAlerts > 0
                      ? 'Revisar inventario'
                      : 'Stock en niveles óptimos',
                  icon: Icons.report_problem_outlined,
                  iconColor: AppColors.error,
                  onTap: () => context.go('/inventory'),
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'GANANCIA NETA',
                  value: '\$${dashboard.netProfit.toStringAsFixed(0)}',
                  subtitle: 'Margen global ${dashboard.globalMargin}%',
                  icon: Icons.balance_outlined,
                  iconColor: Colors.yellow[800]!,
                  onTap: () => context.go('/sales'),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        MonthlyBalanceCard(
          totalCollected: dashboard.monthlyCollected,
          operatingExpenses: dashboard.monthlyExpenses,
          finalAmount: dashboard.monthlyFinalAmount,
        ),

        const SizedBox(height: 16),

        CategoryProfitabilityCard(
          items: dashboard.profitabilityByCategory,
          totalSalesConsolidated: dashboard.totalInvoiced.toStringAsFixed(0),
          totalCostsConsolidated: totalSupplyCosts.toStringAsFixed(0),
          totalNetProfitConsolidated: dashboard.netProfit.toStringAsFixed(0),
          averageMarginConsolidated: dashboard.globalMargin,
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final int columns = constraints.maxWidth < 600 ? 1 : 3;
            final cardWidth =
                (constraints.maxWidth - ((columns - 1) * 16)) / columns;

            return Wrap(
              spacing: 16,
              runSpacing: 16,

              children: [
                PaymentMethodsCard(
                  width: cardWidth,
                  items: dashboard.incomeByPaymentMethod,
                ),

                AppliedDiscountsCard(
                  width: cardWidth,
                  totalAmount: "-\$${totalDiscounts.toStringAsFixed(0)}",
                  items: dashboard.appliedDiscounts,
                ),

                RegisteredExpensesCard(
                  width: cardWidth,
                  totalAmount: "-\$${totalExpenses.toStringAsFixed(0)}",
                  items: dashboard.registeredExpenses,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
