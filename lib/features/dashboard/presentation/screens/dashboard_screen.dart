import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

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
                final bool isDesktop = constraints.maxWidth > 900;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 2, child: _buildLeftColumn(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLeftColumn(context),

                        const SizedBox(height: 24),

                        _buildRightColumn(context),
                      ],
                    ),
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
                _buildSummaryCard(
                  context,
                  width: cardWidth,
                  title: 'TOTAL DE VENTAS DEL DÍA',
                  value: '\$45.250',
                  subtitle: '+12% vs. ayer',
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                ),

                _buildSummaryCard(
                  context,
                  width: cardWidth,
                  title: 'ÓRDENES ACTIVAS',
                  value: '24',
                  subtitle: '8 con diseño pendiente',
                  icon: Icons.precision_manufacturing_outlined,
                  iconColor: Colors.deepPurple,
                ),

                _buildSummaryCard(
                  context,
                  width: cardWidth,
                  title: 'ALERTAS DE STOCK',
                  value: '3',
                  subtitle: 'PLA Negro, MDF 3mm, Acrílico 3mm',
                  icon: Icons.report_problem_outlined,
                  iconColor: AppColors.error,
                ),

                _buildSummaryCard(
                  context,
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

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Resumen de Producción",
                    style: context.textTheme.titleMedium,
                  ),
                  TextButton(onPressed: () {}, child: Text("Ver Todo")),
                ],
              ),

              // TODO: Tabla de producción
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Acciones Rápidas", style: context.textTheme.titleMedium),

              const SizedBox(height: 16),

              _buildQuickActionButton(
                label: 'Nueva Venta',
                icon: Icons.point_of_sale_outlined,
              ),

              const SizedBox(height: 16),

              _buildQuickActionButton(
                label: 'Nueva Órden de Trabajo',
                icon: Icons.add_box_outlined,
              ),

              const SizedBox(height: 16),

              _buildQuickActionButton(
                label: 'Registrar Material',
                icon: Icons.draw_outlined,
              ),

              const SizedBox(height: 16),

              _buildQuickActionButton(
                label: 'Registar Retazo',
                icon: Icons.content_cut_outlined,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(
                    "Últimos Movimientos",
                    style: context.textTheme.titleMedium,
                  ),
                  Icon(Icons.history, color: AppColors.onBackground, size: 20),
                ],
              ),

              const SizedBox(height: 24),

              _buildRecentMovement(
                context,
                title: 'ORD-088 marcada como Hecho.',
                subtitle: 'Stock actualizado: -150g PLA Negro',
                time: 'Hace 10 min.',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              _buildRecentMovement(
                context,
                title: 'Nueva venta registrada.',
                subtitle: 'Monto: \$2.500 (Mercado Pago)',
                time: 'Hace 45 min.',
                icon: Icons.point_of_sale_outlined,
                color: AppColors.primary,
              ),

              const SizedBox(height: 8),

              Divider(color: AppColors.outline),

              TextButton(
                onPressed: () {},
                child: Text(
                  "Ver Historial Completo",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required double width,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: width,

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outline),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              Icon(icon, color: iconColor, size: 20),
            ],
          ),

          const SizedBox(height: 16),

          Text(value, style: context.textTheme.titleLarge),

          const SizedBox(height: 16),

          Text(subtitle, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
  }) {
    return OutlinedButton.icon(
      onPressed: () {},
      label: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label)],
      ),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.onBackground,
        size: 16,
      ),
      iconAlignment: IconAlignment.end,
    );
  }

  Widget _buildRecentMovement(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: color),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(title, style: context.textTheme.bodyMedium),
            Text(subtitle, style: context.textTheme.bodyLarge),
            Text(time, style: context.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
