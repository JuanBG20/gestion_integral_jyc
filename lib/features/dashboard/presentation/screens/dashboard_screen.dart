import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/production_summary_table.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/summary_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);
    final salesState = ref.watch(saleProvider);
    final materialsState = ref.watch(rawMaterialProvider);

    final now = DateTime.now();

    // Ventas del Día
    final ventasHoy = salesState.maybeWhen(
      data: (sales) {
        final salesHoy = sales.where(
          (s) =>
              s.date.year == now.year &&
              s.date.month == now.month &&
              s.date.day == now.day,
        );
        return salesHoy.fold(0.0, (sum, item) => sum + item.finalAmount);
      },
      orElse: () => 0.0,
    );

    // Órdenes Activas (No finalizadas)
    final ordenesActivas = worksState.maybeWhen(
      data: (works) =>
          works.where((w) => w.actualState != WorkState.finalizado).toList(),
      orElse: () => [],
    );
    final disenosPendientes = ordenesActivas
        .where((w) => w.actualState == WorkState.recibido)
        .length;

    // Alertas de Stock
    final alertasStock = materialsState.maybeWhen(
      data: (materials) =>
          materials.where((m) => m.stock <= m.minStock).toList(),
      orElse: () => [],
    );

    // Facturas Pendientes
    final facturasPendientes = salesState.maybeWhen(
      data: (sales) => sales.where((s) => !s.isInvoiced).length,
      orElse: () => 0,
    );

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
                      Expanded(
                        flex: 2,
                        child: _buildLeftColumn(
                          context,
                          ref,
                          ventasHoy,
                          ordenesActivas.length,
                          disenosPendientes,
                          alertasStock.length,
                          facturasPendientes,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(
                        context,
                        ref,
                        ventasHoy,
                        ordenesActivas.length,
                        disenosPendientes,
                        alertasStock.length,
                        facturasPendientes,
                      ),

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

  Widget _buildLeftColumn(
    BuildContext context,
    WidgetRef ref,
    double ventasHoy,
    int totalActivas,
    int disenosPendientes,
    int alertasStock,
    int facturasPendientes,
  ) {
    final isRoot = ref.watch(isRootProvider);

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
                  value: '\$${ventasHoy.toStringAsFixed(2)}',
                  subtitle: 'Actualizado hoy',
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ÓRDENES ACTIVAS',
                  value: totalActivas.toString(),
                  subtitle: '$disenosPendientes con diseño pendiente',
                  icon: Icons.precision_manufacturing_outlined,
                  iconColor: Colors.deepPurple,
                ),

                SummaryCard(
                  width: cardWidth,
                  title: 'ALERTAS DE STOCK DE MATERIA PRIMA',
                  value: alertasStock.toString(),
                  subtitle: alertasStock > 0
                      ? 'Revisar inventario'
                      : 'Stock en niveles óptimos',
                  icon: Icons.report_problem_outlined,
                  iconColor: AppColors.error,
                ),

                if (isRoot)
                  SummaryCard(
                    width: cardWidth,
                    title: 'FACTURAS PENDIENTES',
                    value: facturasPendientes.toString(),
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

        // TODO: Últimos movimientos
        /* const SizedBox(height: 16),
        LatestMoves(), */
      ],
    );
  }
}
