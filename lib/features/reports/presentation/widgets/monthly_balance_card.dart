import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class MonthlyBalanceCard extends StatelessWidget {
  final double totalCollected;
  final double operatingExpenses;
  final double finalAmount;
  final double pendingCollection;
  final double pendingExpenses;

  const MonthlyBalanceCard({
    super.key,
    required this.totalCollected,
    required this.operatingExpenses,
    required this.finalAmount,
    required this.pendingCollection,
    required this.pendingExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          if (context.isMobileLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildMetricBox(context, isCompact: true),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: _buildHeader(context)),
              const SizedBox(width: 16),
              _buildMetricBox(context, isCompact: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),

          child: Icon(Icons.payments_outlined, color: Colors.white),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Balance Mensual", style: context.textTheme.titleSmall),

              const SizedBox(height: 4),

              Text(
                "Total cobrado menos gastos operativos del mes.",
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricBox(BuildContext context, {required bool isCompact}) {
    final mathRow = isCompact
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  label: "INGRESOS",
                  value: "+\$${totalCollected.toStringAsFixed(0)}",
                  color: AppColors.onBackground,
                  align: CrossAxisAlignment.start,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text("-", style: context.textTheme.titleMedium),
              ),

              Expanded(
                child: _buildMetricItem(
                  context,
                  label: "GASTOS",
                  value: "-\$${operatingExpenses.toStringAsFixed(0)}",
                  color: AppColors.error,
                  align: CrossAxisAlignment.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text("=", style: context.textTheme.titleMedium),
              ),

              Expanded(
                child: _buildMetricItem(
                  context,
                  label: "MONTO FINAL",
                  value: "\$${finalAmount.toStringAsFixed(0)}",
                  color: AppColors.primary,
                  align: CrossAxisAlignment.end,
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              _buildMetricItem(
                context,
                label: "INGRESOS",
                value: "+\$${totalCollected.toStringAsFixed(0)}",
                color: AppColors.onBackground,
                align: CrossAxisAlignment.end,
              ),

              const SizedBox(width: 16),
              Text("-", style: context.textTheme.titleLarge),
              const SizedBox(width: 16),

              _buildMetricItem(
                context,
                label: "GASTOS",
                value: "-\$${operatingExpenses.toStringAsFixed(0)}",
                color: AppColors.error,
                align: CrossAxisAlignment.end,
              ),

              const SizedBox(width: 16),
              Text("=", style: context.textTheme.titleLarge),
              const SizedBox(width: 16),

              _buildMetricItem(
                context,
                label: "MONTO FINAL",
                value: "\$${finalAmount.toStringAsFixed(0)}",
                color: AppColors.primary,
                align: CrossAxisAlignment.end,
              ),
            ],
          );

    return Container(
      width: isCompact ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isCompact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,

        children: [
          mathRow,

          if (pendingExpenses > 0 || pendingCollection > 0) ...[
            Padding(
              padding: const EdgeInsetsGeometry.only(top: 12),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 6),

                  Flexible(
                    child: Text(
                      "Dinero sin cobrar: \$${pendingCollection.toStringAsFixed(0)} | Gastos sin pagar: \$${pendingExpenses.toStringAsFixed(0)}",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required CrossAxisAlignment align,
  }) {
    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,

      children: [
        FittedBox(
          fit: BoxFit.scaleDown,

          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 2),

        FittedBox(
          fit: BoxFit.scaleDown,

          child: Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
