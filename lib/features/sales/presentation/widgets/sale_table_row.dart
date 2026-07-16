import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:go_router/go_router.dart';

class SaleTableRow extends StatelessWidget {
  final SaleEntity sale;
  final double trailingWidth;

  const SaleTableRow({
    super.key,
    required this.sale,
    required this.trailingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: trailingWidth,
      trailing: trailingWidth != 0
          ? AppActionMenu(
              items: [
                const AppActionMenuItem(
                  value: 'detail',
                  label: 'Ver Detalle',
                  icon: Icons.visibility_outlined,
                ),

                if (!sale.isInvoiced)
                  AppActionMenuItem(value: 'bill', label: 'Facturar'),
              ],
              onSelected: (value) => _handleSaleAction(context, value),
            )
          : null,

      cells: [
        AppTableCell.text(
          'VTA-${sale.id ?? ''}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          sale.client.fullName,
          flex: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          sale.date.ddMMyyyy,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          sale.paymentMethod.dbValue,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          '\$${sale.finalAmount.toStringAsFixed(2)}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,

            child: _buildArcaIndicator(context, hasCae: sale.isInvoiced),
          ),
        ),
      ],
    );
  }

  Widget _buildArcaIndicator(BuildContext context, {required bool hasCae}) {
    if (hasCae) {
      return Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(
            "CAE",
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Icon(Icons.description_outlined, color: AppColors.primary);
  }

  void _handleSaleAction(BuildContext context, String action) {
    switch (action) {
      case 'detail':
        context.go('/sales/detail', extra: sale);
      case 'bill':
        context.go('/sales/detail/bill', extra: sale);
    }
  }
}
