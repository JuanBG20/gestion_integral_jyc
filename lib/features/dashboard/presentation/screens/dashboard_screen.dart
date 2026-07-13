import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/latest_moves.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/production_summary_table.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Resumen", style: context.textTheme.titleLarge),
            Text(
              "Métricas y estado de la producción diario.",
              style: context.textTheme.bodyLarge,
            ),

            const SizedBox(height: 8),

            const Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.isDesktopLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 2, child: _buildLeftColumn(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context),

                      const SizedBox(height: 24),

                      _buildRightColumn(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

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
                  title: 'TOTAL DE VENTAS DEL DÍA',
                  value: '\$45.250',
                  subtitle: '+12% vs. ayer',
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ÓRDENES ACTIVAS',
                  value: '24',
                  subtitle: '8 con diseño pendiente',
                  icon: Icons.precision_manufacturing_outlined,
                  iconColor: Colors.deepPurple,
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ALERTAS DE STOCK',
                  value: '3',
                  subtitle: 'PLA Negro, MDF 3mm, Acrílico 3mm',
                  icon: Icons.report_problem_outlined,
                  iconColor: AppColors.error,
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'FACTURAS PENDIENTES',
                  value: '12',
                  subtitle: 'Listas para facturar',
                  icon: Icons.receipt_long_outlined,
                  iconColor: Colors.yellow[800]!,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        ProductionSummaryTable(),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        DashboardQuickActions(),
        const SizedBox(height: 16),
        LatestMoves(),
      ],
    );
  }
}
