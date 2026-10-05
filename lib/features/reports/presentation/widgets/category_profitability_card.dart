import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/category_profitability_item_entity.dart';

class CategoryProfitabilityCard extends StatelessWidget {
  final List<CategoryProfitabilityItemEntity> items;
  final String totalSalesConsolidated;
  final String totalCostsConsolidated;
  final String totalNetProfitConsolidated;
  final double averageMarginConsolidated;

  const CategoryProfitabilityCard({
    super.key,
    required this.items,
    required this.totalSalesConsolidated,
    required this.totalCostsConsolidated,
    required this.totalNetProfitConsolidated,
    required this.averageMarginConsolidated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Cabecera superior
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rentabilidad y Ganancias por Categoría",
                  style: context.textTheme.titleMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  "Determinación exacta de cuánto dinero neto genera cada línea de producción.",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = constraints.maxWidth > 850
                  ? constraints.maxWidth
                  : 850.0;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: SizedBox(
                  width: tableWidth,

                  child: Column(
                    children: [
                      // Cabecera de columnas
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),

                        child: Row(
                          children: [
                            _buildColHeader(
                              "CATEGORÍA DE PRODUCTO",
                              flex: 4,
                              alignment: Alignment.centerLeft,
                              context: context,
                            ),

                            _buildColHeader(
                              "TOTAL VENTAS",
                              flex: 3,
                              alignment: Alignment.centerRight,
                              context: context,
                            ),

                            _buildColHeader(
                              "COSTO INSUMOS",
                              flex: 3,
                              alignment: Alignment.centerRight,
                              context: context,
                            ),

                            _buildColHeader(
                              "GANANCIA NETA",
                              flex: 3,
                              alignment: Alignment.centerRight,
                              context: context,
                            ),

                            _buildColHeader(
                              "MARGEN",
                              flex: 2,
                              alignment: Alignment.center,
                              context: context,
                            ),

                            _buildColHeader(
                              "DISTRIBUCIÓN DE UTILIDAD",
                              flex: 4,
                              alignment: Alignment.centerRight,
                              context: context,
                            ),
                          ],
                        ),
                      ),

                      const Divider(color: AppColors.outline),

                      // Lista de Categorías
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,

                        separatorBuilder: (_, _) =>
                            const Divider(color: AppColors.outline),

                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),

                            child: Row(
                              children: [
                                // Categoría
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    item.category,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Total Ventas
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.totalSales,
                                    textAlign: TextAlign.right,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ),

                                // Costo Insumos
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.supplyCosts,
                                    textAlign: TextAlign.right,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ),

                                // Ganancia Neta
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.netProfit,
                                    textAlign: TextAlign.right,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ),

                                // Margen
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(4),
                                      ),

                                      child: Text(
                                        "${item.marginPercent.toStringAsFixed(1)}%",
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),

                                // Distribución de Utilidad
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),

                                        child: LinearProgressIndicator(
                                          value:
                                              item.utilityDistributionPercent /
                                              100,
                                          backgroundColor: AppColors.primary
                                              .withValues(alpha: 0.2),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primary,
                                              ),
                                          minHeight: 8,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "${item.utilityDistributionPercent.toStringAsFixed(1)}% del total",
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Fila Total Consolidado
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border(
                            top: BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                "TOTAL CONSOLIDADO",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Text(
                                '\$$totalSalesConsolidated',
                                textAlign: TextAlign.right,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Text(
                                '\$$totalCostsConsolidated',
                                textAlign: TextAlign.right,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Text(
                                '\$$totalNetProfitConsolidated',
                                textAlign: TextAlign.right,
                                style: context.textTheme.titleMedium,
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),

                                  child: Text(
                                    "${averageMarginConsolidated.toStringAsFixed(1)}%",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                            const Expanded(flex: 4, child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColHeader(
    String label, {
    required int flex,
    required Alignment alignment,
    required BuildContext context,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Text(label, style: context.textTheme.bodySmall),
      ),
    );
  }
}
